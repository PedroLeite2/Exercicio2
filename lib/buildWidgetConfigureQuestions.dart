import 'package:avaliacaoex2/buildWidgetQuestions.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';

Widget buildWidgetConfigureQuestions() {
  return const ConfigureQuestionsPage();
}

Map<int, String> nivel = {
  1: 'Fácil',
  2: 'Médio',
  3: 'Difícil',
};

Map<int, String> tipo = {
  1: 'Endereços',
  2: 'Sub-redes',
  3: 'Super-redes',
};

class ConfigureQuestionsPage extends StatefulWidget {
  final String? nomeUtilizador;

  const ConfigureQuestionsPage({super.key, this.nomeUtilizador});

  @override
  State<ConfigureQuestionsPage> createState() => _ConfigureQuestionsPageState();
}

class _ConfigureQuestionsPageState extends State<ConfigureQuestionsPage> {
  int? _nivelSelecionado;
  int? _tipoSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
       
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_conf_questions.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

         
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Bem-vindo, ${widget.nomeUtilizador ?? ''}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 140),

                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Configurar Questões',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Seleciona o Nível',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                _buildDropdownContainer(
                  _nivelSelecionado,
                  'Escolhe o nível',
                  nivel,
                  (valor) => setState(() => _nivelSelecionado = valor),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Seleciona o Tipo de Questão',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                _buildDropdownContainer(
                  _tipoSelecionado,
                  'Escolhe o tipo',
                  tipo,
                  (valor) => setState(() => _tipoSelecionado = valor),
                ),

                const SizedBox(height: 40),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      if (_nivelSelecionado != null && _tipoSelecionado != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionsPage(
                              nivelSelecionado: _nivelSelecionado!,
                              tipoSelecionado: _tipoSelecionado!,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, seleciona o nível e o tipo.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Começar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownContainer(
    int? valorAtual,
    String textoHint,
    Map<int, String> opcoes,
    ValueChanged<int?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: valorAtual,
          hint: Center(child: Text(textoHint)),
          onChanged: onChanged,
          items: opcoes.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Center(
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
