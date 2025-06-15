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
  int score = 0;
  bool showResult = false;
  final formKey = GlobalKey<FormState>();

  void count() {
    if (_controller.text.trim().toLowerCase() ==
        respostaCorreta.toLowerCase()) {
      setState(() {
        score++;
      });
    }

    if (indexPergunta < 3) {
      setState(() {
        indexPergunta++;
        _controller.clear();
      });
    } else {
      setState(() {
        showResult = true;
      });
    }
  }

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
    return widget.selectedType;
  }

  String createQuestion(int pergunta) {
    final int t = type();
    final int prefixo = createMaskRandom(t);
    String ip1;
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
      ip1 = createIpRandomSuperRedes();
      ip2 = generateIpInSameSubnet(ip1, prefixo);
      respostaCorreta = 'sim'; // Resposta fixa para pergunta 3
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
        return 'Os endereços IPs $ip1 e $ip2 estão no mesmo segmento de rede com máscara /$prefixo? (responda "sim" ou "não")';
      default:
        return 'Sem pergunta disponível.';
    }
  }

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
      return createIpRandomEnderecos(prefixo);
    } else if (type == 2) {
      return createIpRandomSubRedes(prefixo);
    } else if (type == 3) {
      return createIpRandomSuperRedes();
    } else {
      throw ArgumentError('Tipo inválido: $type');
    }
  }

  String createIpRandomSubRedes(int prefixo) {
    if (prefixo <= 15) {
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
          // Imagem de fundo
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

          // Overlay escuro
          Container(color: Colors.black.withOpacity(0.3)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cabeçalho com nome do usuário e botão de voltar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
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

                  // Indicador de progresso
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

                  const SizedBox(height: 30),

                  // Card da pergunta
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.white.withOpacity(0.85),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade50,
                                        ),
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                            ? 'Por favor, insira sua resposta.'
                                            : null,
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: count,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.amber.shade600,
                                            padding: const EdgeInsets.symmetric(
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
                                        'Você acertou $score de 3 questões!',
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
                                          backgroundColor: Colors.blue.shade700,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 24,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                    ],
                                  ],
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
