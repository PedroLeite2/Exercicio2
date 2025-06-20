import 'package:avaliacaoex2/questions_widget.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'score_widget.dart';

Widget buildWidgetConfigureQuestions() {
  return ConfigureQuestionsPage();
}

Map<int, String> typeMap = {1: 'Endereços', 2: 'Sub-redes', 3: 'Super-redes'};

class ConfigureQuestionsPage extends StatefulWidget {
  const ConfigureQuestionsPage({super.key});

  @override
  State<ConfigureQuestionsPage> createState() => _ConfigureQuestionsPageState();
}

class _ConfigureQuestionsPageState extends State<ConfigureQuestionsPage> {
  @override
  void initState() {
    super.initState();
    carregarNome();
  }

  String? userName;

  Future<void> carregarNome() async {
    final resultado = await DatabaseHelper.instance.getLoggedUser();

    setState(() {
      userName = resultado ?? '';
    });
  }

  int? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo original
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

          // Overlay escuro para melhor legibilidade
          Container(color: Colors.black.withOpacity(0.3)),

          // Conteúdo principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cabeçalho com saudação ao utilizador
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
                          'Bem-vindo, ${userName ?? 'Utilizador'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Título
                  const Text(
                    'Selecione o tipo de questão',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Cartões de configuração
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),

                          _buildSelectionCard(
                            title: 'Tipo de Questão',
                            hint: 'Escolha o tipo',
                            value: _selectedType,
                            options: typeMap,
                            icon: Icons.category,
                            onChanged: (value) =>
                                setState(() => _selectedType = value),
                          ),

                          const SizedBox(height: 40),

                          // Botão de início
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber.shade600,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(0.3),
                              ),
                              onPressed: () {
                                if (_selectedType != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuestionsPage(
                                        nameUser: userName!,
                                        selectedType: _selectedType!,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.red.shade400,
                                      content: const Text(
                                        'Por favor, selecione o tipo!',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Iniciar Quiz',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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

  Widget _buildSelectionCard({
    required String title,
    required String hint,
    required int? value,
    required Map<int, String> options,
    required IconData icon,
    required ValueChanged<int?> onChanged,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.85),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: value,
                  hint: Text(
                    hint,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey.shade600,
                  ),
                  iconSize: 28,
                  dropdownColor: Colors.white,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: onChanged,
                  items: options.entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(entry.value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
