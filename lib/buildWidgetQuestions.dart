import 'dart:math';
import 'package:flutter/material.dart';

class Pergunta {
  final String texto;
  final String resposta;

  Pergunta({required this.texto, required this.resposta});
}

class QuestionsPage extends StatefulWidget {
  final String nameUser;
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
int indexPergunta=1;

  final TextEditingController _controller = TextEditingController();
 
void count(){
  setState(() {
    
     indexPergunta++;
  
  });
 
}
int type(){
int type = widget.selectedType;
return type;
}
  

  String createQuestion( int pergunta) {
  
    int prefixo = createMaskRandom(type());
    String ip1 = createIpRandomEnderecos(prefixo);
    String ip2 = createIpRandomEnderecos(prefixo);

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

  String createIpRandomSubRedes(int prefixo) {
    switch (prefixo) {
      case 8-30:
        return '10.${Random().nextInt(256)}.${Random().nextInt(256)}.${Random().nextInt(256)}';
      case 16-23:
        return '172.${16 + Random().nextInt(16)}.${Random().nextInt(256)}.${Random().nextInt(256)}';
      case 24-30:
        return '192.168.${Random().nextInt(256)}.${Random().nextInt(256)}';
      default:
        return '';
    }
  }

  String createIpRandomSuperRedes(int classe) {
    switch (classe) {
      case 1:
        return '10.${Random().nextInt(256)}.${Random().nextInt(256)}.${Random().nextInt(256)}';
      case 2:
        return '172.${16 + Random().nextInt(16)}.${Random().nextInt(256)}.${Random().nextInt(256)}';
      case 3:
        return '192.168.${Random().nextInt(256)}.${Random().nextInt(256)}';
      default:
        return '';
    }
  }

  int createMaskRandom(int type) {
    int mask = 0; // Default to Class C
    if (type == 1) {
      List<int> prefixes = [8, 16, 24];

      mask = prefixes[Random().nextInt(prefixes.length)];
    } else {
      mask = 8 + Random().nextInt(23);
    }
    return mask;
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
                      Visibility(visible:indexPergunta==1 ,
                        child: 

                      Text(
                        createQuestion(1),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),),
                      Visibility(visible:indexPergunta==2,
                      child: 
                      Text(
                        createQuestion(2),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),),
                      Visibility(visible:indexPergunta==3,
                      child: 
                      Text(
                        createQuestion(3),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),),
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
                      Visibility(visible:indexPergunta==4,
                      child: 
                      Text(
                        'Resultado',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: count,
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

