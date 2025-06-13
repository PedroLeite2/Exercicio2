import 'package:avaliacaoex2/buildWidgetQuestions.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';

Widget buildWidgetConfigureQuestions({String? userName}) {
  return ConfigureQuestionsPage(userName: userName);
}

Map<int, String> levelMap = {
  1: 'Fácil',
  2: 'Médio',
  3: 'Difícil',
};

Map<int, String> typeMap = {
  1: 'Endereços',
  2: 'Sub-redes',
  3: 'Super-redes',
};

class ConfigureQuestionsPage extends StatefulWidget {
  final String? userName;

  const ConfigureQuestionsPage({super.key, this.userName});

  @override
  State<ConfigureQuestionsPage> createState() => _ConfigureQuestionsPageState();
}

class _ConfigureQuestionsPageState extends State<ConfigureQuestionsPage> {
  int? _selectedLevel;
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
                image: AssetImage('assets/images/background_conf_questions.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay escuro para melhor legibilidade
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

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
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Bem-vindo, ${widget.userName ?? 'Utilizador'}',
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
                    'Configurar Questões',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Personalize a sua experiência de quiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Cartões de configuração
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildSelectionCard(
                            title: 'Nível de Dificuldade',
                            hint: 'Escolha o nível',
                            value: _selectedLevel,
                            options: levelMap,
                            icon: Icons.speed,
                            onChanged: (value) =>
                                setState(() => _selectedLevel = value),
                          ),

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
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(0.3),
                              ),
                              onPressed: () {
                                if (_selectedLevel != null && _selectedType != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuestionsPage(
                                        nivelSelecionado: _selectedLevel!,
                                        tipoSelecionado: _selectedType!,
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
                                        'Por favor, selecione o nível e o tipo!',
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white.withOpacity(0.85),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
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
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: value,
                  hint: Text(
                    hint,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
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