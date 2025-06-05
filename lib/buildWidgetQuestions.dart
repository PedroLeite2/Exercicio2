import 'dart:math';
import 'package:flutter/material.dart';

class Pergunta {
  final String texto;
  final String resposta;

  Pergunta({required this.texto, required this.resposta});
}

class QuestionsPage extends StatefulWidget {
  final int nivelSelecionado;
  final int tipoSelecionado;

  const QuestionsPage({
    super.key,
    required this.nivelSelecionado,
    required this.tipoSelecionado,
  });

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  late Pergunta perguntaAtual;
  final TextEditingController _controller = TextEditingController();
  String feedback = '';

  @override
  void initState() {
    super.initState();
    perguntaAtual = gerarPergunta(widget.nivelSelecionado, widget.tipoSelecionado);
  }

  void verificarResposta() {
    String respostaUser = _controller.text.trim();
    if (respostaUser.toLowerCase() == perguntaAtual.resposta.toLowerCase()) {
      setState(() {
        feedback = '✅ Resposta correta!';
      });
    } else {
      setState(() {
        feedback = '❌ Resposta errada. A correta era: ${perguntaAtual.resposta}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Pergunta de Rede'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        perguntaAtual.texto,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Resposta',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: verificarResposta,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Verificar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        feedback,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: feedback.startsWith('✅') ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Pergunta gerarPergunta(int nivel, int tipo) {
  if (nivel == 1 && tipo == 1) return gerarPerguntaNivel1();
  if (nivel == 2 && tipo == 2) return gerarPerguntaCompararIPs(24);
  if (nivel == 3 && tipo == 3) return gerarPerguntaCompararIPs(20);
  return Pergunta(texto: 'Sem pergunta disponível.', resposta: '');
}

Pergunta gerarPerguntaNivel1() {
  final random = Random();
  int classe = random.nextInt(3);
  int ip1 = classe == 0 ? 10 : classe == 1 ? 172 : 192;
  int ip2 = classe == 1 ? (16 + random.nextInt(16)) : random.nextInt(256);
  int ip3 = random.nextInt(256);
  int ip4 = random.nextInt(256);
  String ip = '$ip1.$ip2.$ip3.$ip4';

  List<int> prefixos = [8, 16, 24];
  int prefixo = prefixos[random.nextInt(prefixos.length)];
  String mascara = prefixoToMascara(prefixo);

  bool isNetwork = random.nextBool();
  String resposta = isNetwork
      ? calcularNetworkID(ip, mascara)
      : calcularBroadcast(ip, mascara);
  String texto = isNetwork
      ? 'Qual é o Network ID do endereço IP $ip com máscara /$prefixo?'
      : 'Qual é o Broadcast do endereço IP $ip com máscara /$prefixo?';
  return Pergunta(texto: texto, resposta: resposta);
}

Pergunta gerarPerguntaCompararIPs(int prefixo) {
  final ip1 = gerarIpPrivado();
  final ip2 = gerarIpPrivado();
  final mascara = prefixoToMascara(prefixo);

  final net1 = calcularNetworkID(ip1, mascara);
  final net2 = calcularNetworkID(ip2, mascara);
  final mesmaRede = net1 == net2;

  return Pergunta(
    texto: 'Os endereços $ip1 e $ip2 estão na mesma rede com máscara /$prefixo?',
    resposta: mesmaRede ? 'Sim' : 'Não',
  );
}

String gerarIpPrivado() {
  final random = Random();
  int classe = random.nextInt(3);
  int ip1 = classe == 0 ? 10 : classe == 1 ? 172 : 192;
  int ip2 = classe == 1 ? (16 + random.nextInt(16)) : random.nextInt(256);
  int ip3 = random.nextInt(256);
  int ip4 = random.nextInt(256);
  return '$ip1.$ip2.$ip3.$ip4';
}

String prefixoToMascara(int prefixo) {
  int fullOctets = prefixo ~/ 8;
  int remainingBits = prefixo % 8;

  List<int> octets = List.filled(4, 0);
  for (int i = 0; i < fullOctets; i++) {
    octets[i] = 255;
  }
  if (remainingBits > 0 && fullOctets < 4) {
    octets[fullOctets] = 256 - (1 << (8 - remainingBits));
  }
  return octets.join('.');
}

String calcularNetworkID(String ip, String mascara) {
  List<int> ipOctets = ip.split('.').map(int.parse).toList();
  List<int> maskOctets = mascara.split('.').map(int.parse).toList();
  List<int> network = List.generate(4, (i) => ipOctets[i] & maskOctets[i]);
  return network.join('.');
}

String calcularBroadcast(String ip, String mascara) {
  List<int> ipOctets = ip.split('.').map(int.parse).toList();
  List<int> maskOctets = mascara.split('.').map(int.parse).toList();
  List<int> broadcast = List.generate(
    4,
    (i) => (ipOctets[i] & maskOctets[i]) | (~maskOctets[i] & 0xFF),
  );
  return broadcast.join('.');
}
