import 'dart:math';
import 'package:avaliacaoex2/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';

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
  int corretas = 0;
  int score = 0;
  bool showResult = false;
  final formKey = GlobalKey<FormState>();
  bool valido = false;

  // Calcula a pontuação com base na resposta e tipo de pergunta
  int pontuacao(bool resposta) {
    return (type() * (resposta ? 10 : -5));
  }

  // Atualiza a pontuação do utilizador na base de dados
  Future<int?> atualizarScore() async {
    await DatabaseHelper.instance.updateUserScore(widget.nameUser!, score);
    return await DatabaseHelper.instance.getUserScore(widget.nameUser!);
  }

  // Verifica se a resposta está certa, atualiza score e estado
  void confirmar() async {
    bool estaCerta =
        removeDiacritics(_controller.text.trim().toLowerCase()) ==
        respostaCorreta.toLowerCase();

    setState(() {
      score += pontuacao(estaCerta);
      if (estaCerta) corretas++;
      indexPergunta++;
      _controller.clear();
    });

    if (indexPergunta > 3) {
      showResult = true;
      int? tempScore = await atualizarScore();
      setState(() {
        score = tempScore!;
      });
    }
  }

  // Calcula o Network ID dado um IP e prefixo
  String calculateNetworkId(String ip, int prefix) {
    final ipInt = ipToInt(ip);
    final mask = prefixToMask(prefix);
    final networkInt = ipInt & mask;
    return intToIp(networkInt);
  }

  // Calcula o endereço de broadcast com base no Network ID e prefixo
  String calculateBroadcastAddress(String networkId, int prefixo) {
    int networkInt = ipToInt(networkId);
    int mask = prefixToMask(prefixo);
    int broadcastInt = networkInt | (~mask & 0xFFFFFFFF);
    return intToIp(broadcastInt);
  }

  // Retorna o tipo de pergunta selecionado
  int type() {
    return widget.selectedType;
  }

  // Cria uma pergunta com base no tipo e número da pergunta
  String createQuestion(int pergunta) {
    final int t = type();
    final int prefixo = createMaskRandom(t);
    String ip1 = '';
    String? ip2;

    if (pergunta == 1) {
      ip1 = createIp(prefixo, t);
      respostaCorreta = calculateNetworkId(ip1, prefixo);
    } else if (pergunta == 2) {
      ip1 = createIp(prefixo, t);
      ip2 = generateIpInSameSubnet(ip1, prefixo);
      String networkId = calculateNetworkId(ip1, prefixo);
      respostaCorreta = calculateBroadcastAddress(networkId, prefixo);
    } else if (pergunta == 3) {
      bool verdadeira = Random().nextInt(2) == 1;
      ip1 = createIpRandomSuperRedes();

      if (verdadeira) {
        ip2 = generateIpInSameSubnet(ip1, prefixo);
        respostaCorreta = 'sim';
      } else {
        String networkId = calculateNetworkId(ip1, prefixo);
        ip2 = createIpRandomSuperRedes();
        while (networkId == calculateNetworkId(ip2!, prefixo)) {
          ip2 = createIpRandomSuperRedes();
        }
        respostaCorreta = 'nao';
      }
    }

    return questionTemplate(
      ip1: ip1,
      ip2: ip2,
      prefixo: prefixo,
      pergunta: pergunta,
    );
  }

  // Retorna o texto da pergunta formatado
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
        return 'Os endereços IPs $ip1 e $ip2 estão no mesmo segmento de rede com máscara /$prefixo? (responda "sim" ou "não")';
      default:
        return 'Sem pergunta disponível.';
    }
  }

  // Gera um IP aleatório com base na classe
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

  // Converte IP (string) para inteiro
  int ipToInt(String ip) {
    final parts = ip.split('.').map(int.parse).toList();
    return (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8) | parts[3];
  }

  // Converte inteiro para IP (string)
  String intToIp(int ip) {
    return '${(ip >> 24) & 0xFF}.${(ip >> 16) & 0xFF}.${(ip >> 8) & 0xFF}.${ip & 0xFF}';
  }

  // Converte prefixo para máscara de sub-rede
  int prefixToMask(int prefix) {
    return 0xFFFFFFFF << (32 - prefix) & 0xFFFFFFFF;
  }

  // Gera IP aleatório dentro da mesma sub-rede
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

  // Cria um IP com base no tipo e prefixo fornecidos
  String createIp(int prefixo, int type) {
    if (type == 1) {
      return createIpRandomEnderecos(prefixo);
    } else if (type == 2) {
      return createIpRandomSubRedes(prefixo);
    } else if (type == 3) {
      return createIpRandomSuperRedes();
    } else {
      throw ArgumentError('Tipo inválido: $type');
    }
  }

  // Cria IP aleatório dentro de uma sub-rede válida
  String createIpRandomSubRedes(int prefixo) {
    List<int> octets;
    if (prefixo <= 15) {
      octets = [
        10,
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
      ];
    } else if (prefixo <= 23) {
      octets = [
        172,
        16 + Random().nextInt(16),
        Random().nextInt(256),
        Random().nextInt(256),
      ];
    } else {
      octets = [192, 168, Random().nextInt(256), Random().nextInt(256)];
    }

    for (int i = 0; i < 32 - min(prefixo, 30); i++) {
      int octetIndex = 3 - (i ~/ 8);
      int bitPosition = i % 8;
      octets[octetIndex] &= ~(1 << bitPosition);
    }

    return octets.join('.');
  }

  String createIpRandomSuperRedes() {
    const testNets = ['192.0.2', '198.51.100', '203.0.113'];
    final base = testNets[Random().nextInt(testNets.length)];
    final host = 1 + Random().nextInt(254);
    return '$base.$host';
  }

  // Gera prefixo de máscara aleatório conforme o tipo de pergunta
  int createMaskRandom(int type) {
    if (type == 1) {
      List<int> prefixes = [8, 16, 24];
      return prefixes[Random().nextInt(prefixes.length)];
    } else if (type == 2) {
      return 25 + Random().nextInt(6);
    } else if (type == 3) {
      return 8 + Random().nextInt(16);
    } else {
      throw ArgumentError('Tipo inválido: $type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background_conf_questions.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Bem-vindo, ${widget.nameUser ?? 'Utilizador'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (showResult) ...[
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white.withOpacity(0.85),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.amber,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            widget.nameUser!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Score: $score pontos',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    LinearProgressIndicator(
                      value: indexPergunta / 3,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      color: Colors.amber,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Questão $indexPergunta de 3',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color: Colors.white.withOpacity(0.85),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (!showResult) ...[
                                        Text(
                                          createQuestion(indexPergunta),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          controller: _controller,
                                          decoration: InputDecoration(
                                            labelText: 'Sua resposta',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey.shade50,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor, insira sua resposta.';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (formKey.currentState !=
                                                      null &&
                                                  formKey.currentState!
                                                      .validate()) {
                                                confirmar();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.amber.shade600,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              'Confirmar',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      if (showResult) ...[
                                        const Text(
                                          'Quiz Concluído!',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          'Você acertou $corretas de 3 questões!',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blue.shade700,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 24,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            'Voltar ao Início',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
