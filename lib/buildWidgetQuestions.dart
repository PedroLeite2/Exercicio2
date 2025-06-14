import 'dart:math';
import 'package:flutter/material.dart';

class Pergunta {
  final String texto;
  final String resposta;

  Pergunta({required this.texto, required this.resposta});
}

class QuestionsPage extends StatefulWidget {
  final String? nameUser;
  final int selectedType;

  const QuestionsPage({
    super.key,
    required this.nameUser,
    required this.selectedType,
  });

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int indexPergunta = 1;

  String respostaCorreta = '';

  final TextEditingController _controller = TextEditingController();

  void count() {
    setState(() {
      indexPergunta++;
    });
  }

  // Resposta para a pergunta 1: Network ID
  String calculateNetworkId(String ip, int prefix) {
    final ipInt = ipToInt(ip);
    final mask = prefixToMask(prefix);
    final networkInt = ipInt & mask;
    return intToIp(networkInt);
  }

  String calculateBroadcastAddress(String networkId, int prefixo) {
    int networkInt = ipToInt(networkId);
    int mask = prefixToMask(prefixo);
    int broadcastInt = networkInt | (~mask & 0xFFFFFFFF);
    return intToIp(broadcastInt);
  }

  int type() {
    int type = widget.selectedType;
    return type;
  }

  String createQuestion(int pergunta) {
    final int t = type();
    final int prefixo = createMaskRandom(t);
    String ip1;
    String? ip2;

    if (pergunta == 1) {
      // endereços “normais” (classe A/B/C)
      ip1 = createIp(prefixo, t);
      respostaCorreta = calculateNetworkId(ip1, prefixo);
    } else if (pergunta == 2) {
      // sub-redes (CIDR dentro de qualquer bloco)
      ip1 = createIp(prefixo, t);
      ip2 = generateIpInSameSubnet(ip1, prefixo);
      String networkId = calculateNetworkId(ip1, prefixo);
      respostaCorreta = calculateBroadcastAddress(networkId, prefixo);
    } else if (pergunta == 3) {
      // super-redes: usa o bloco test‐net + gera segundo IP na mesma super-rede
      ip1 = createIpRandomSuperRedes();
      ip2 = generateIpInSameSubnet(ip1, prefixo);

      // para perguntas 1 e 2 não precisamos do segundo IP
    } else {
      throw ArgumentError('Tipo inválido: $t');
    }

    return questionTemplate(
      ip1: ip1,
      ip2: ip2,
      prefixo: prefixo,
      pergunta: pergunta,
    );
  }

  String questionTemplate({
    required String ip1,
    String? ip2,
    required int prefixo,
    required int pergunta,
  }) {
    switch (pergunta) {
      case 1:
        return 'Qual é o Network ID do endereço IP $ip1 com máscara /$prefixo?';
      case 2:
        return 'Qual é o Broadcast do endereço IP $ip1 com máscara /$prefixo?';
      case 3:
        return 'Os endereços IPs $ip1 e $ip2 estão no mesmo segmento de rede com máscara /$prefixo?';
      default:
        return 'Sem pergunta disponível.';
    }
  }
  /*Classe A: 10.0.0.0 a 10.255.255.255 //pergunta 2

Classe B: 172.16.0.0 a 172.31.255.255 //pergunta 3

Classe C: 192.168.0.0 a 192.168.255.255*/ //pergunta 1

  String createIpRandomEnderecos(int classe) {
    switch (classe) {
      case 8:
        return '10.${Random().nextInt(256)}.${Random().nextInt(256)}.${1 + Random().nextInt(254)}';
      case 16:
        return '172.${16 + Random().nextInt(16)}.${Random().nextInt(256)}.${1 + Random().nextInt(254)}';
      case 24:
        return '192.168.${Random().nextInt(256)}.${1 + Random().nextInt(254)}';
      default:
        return '';
    }
  }

  int ipToInt(String ip) {
    final parts = ip.split('.').map(int.parse).toList();
    return (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8) | parts[3];
  }

  String intToIp(int ip) {
    return '${(ip >> 24) & 0xFF}.${(ip >> 16) & 0xFF}.${(ip >> 8) & 0xFF}.${ip & 0xFF}';
  }

  int prefixToMask(int prefix) {
    return 0xFFFFFFFF << (32 - prefix) & 0xFFFFFFFF;
  }

  String generateIpInSameSubnet(String ip, int prefix) {
    final rand = Random();
    final ipInt = ipToInt(ip);
    final mask = prefixToMask(prefix);
    final network = ipInt & mask;
    final broadcast = network | (~mask & 0xFFFFFFFF);

    int newIpInt;
    do {
      newIpInt = network + 1 + rand.nextInt(broadcast - network - 1);
    } while (newIpInt == ipInt);

    return intToIp(newIpInt);
  }

  String createIp(int prefixo, int type) {
    if (type == 1) {
      // Classe A/B/C originais
      return createIpRandomEnderecos(prefixo);
    } else if (type == 2) {
      // Sub-redes dentro de cada bloco: /25 a /30
      return createIpRandomSubRedes(prefixo);
    } else if (type == 3) {
      // Super-redes (agregação de vários /24): /8 a /23
      return createIpRandomSuperRedes();
    } else {
      throw ArgumentError('Tipo inválido: $type');
    }
  }

  String createIpRandomSubRedes(int prefixo) {
    // Escolhe uma faixa privada baseada no prefixo
    if (prefixo <= 15) {
      // Classe A: 10.0.0.0/8
      List<int> octets = [
        10,
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
      ];
      for (int i = 0; i < 32 - min(prefixo, 30); i++) {
        int octetIndex = 3 - (i ~/ 8);
        int bitPosition = i % 8;
        octets[octetIndex] &= ~(1 << bitPosition);
      }
      return octets.join('.');
    } else if (prefixo <= 23) {
      // Classe B: 172.16.0.0/12
      List<int> octets = [
        172,
        16 + Random().nextInt(16),
        Random().nextInt(256),
        Random().nextInt(256),
      ];
      for (int i = 0; i < 32 - min(prefixo, 30); i++) {
        int octetIndex = 3 - (i ~/ 8);
        int bitPosition = i % 8;
        octets[octetIndex] &= ~(1 << bitPosition);
      }
      return octets.join('.');
    } else {
      // Classe C: 192.168.0.0/16
      List<int> octets = [
        192,
        168,
        Random().nextInt(256),
        Random().nextInt(256),
      ];
      for (int i = 0; i < 32 - min(prefixo, 30); i++) {
        int octetIndex = 3 - (i ~/ 8);
        int bitPosition = i % 8;
        octets[octetIndex] &= ~(1 << bitPosition);
      }
      return octets.join('.');
    }
  }

  String createIpRandomSuperRedes() {
    const testNets = ['192.0.2', '198.51.100', '203.0.113'];
    final base = testNets[Random().nextInt(testNets.length)];
    final host = 1 + Random().nextInt(254);
    return '$base.$host';
  }

  int createMaskRandom(int type) {
    if (type == 1) {
      // classe A/B/C originais
      List<int> prefixes = [8, 16, 24];
      return prefixes[Random().nextInt(prefixes.length)];
    } else if (type == 2) {
      // sub-redes dentro de cada bloco: /25 a /30
      return 25 + Random().nextInt(6); // 25..30
    } else if (type == 3) {
      // super-redes (agregação de vários /24): /8 a /23
      return 8 + Random().nextInt(16); // 8..23
    } else {
      throw ArgumentError('Tipo inválido: $type');
    }
  }

  @override
  void initState() {
    super.initState();
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
                      Visibility(
                        visible: indexPergunta == 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              createQuestion(1),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              respostaCorreta,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: indexPergunta == 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              createQuestion(2),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              respostaCorreta,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: indexPergunta == 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              createQuestion(3),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              respostaCorreta,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
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
                      Visibility(
                        visible: indexPergunta == 4,
                        child: Text(
                          'Resultado',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: count,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Verificar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            170,
                            170,
                            173,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
