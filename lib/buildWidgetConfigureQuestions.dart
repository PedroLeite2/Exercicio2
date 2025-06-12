import 'package:avaliacaoex2/buildWidgetQuestions.dart';
import 'package:flutter/material.dart';

Widget buildWidgetConfigureQuestions() {
  return const ConfigureQuestionsPage();
}

Map<int, String> nivel = {1: 'Fácil', 2: 'Médio', 3: 'Difícil'};

Map<int, String> tipo = {1: 'Endereços', 2: 'Sub-redes', 3: 'Super-redes'};

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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 62.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔸 Título de boas-vindas pequeno à esquerda
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Bem-vindo, ${widget.nomeUtilizador ?? ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // 🔹 Título principal centrado
              Center(
                child: Text(
                  'Configurar Questões',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 🔻 Nível
              const Text(
                'Seleciona o Nível',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _nivelSelecionado,
                    hint: const Center(child: Text('Escolhe o nível')),
                    onChanged: (int? novoValor) {
                      setState(() {
                        _nivelSelecionado = novoValor;
                      });
                    },
                    items: nivel.entries.map<DropdownMenuItem<int>>((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(entry.value, textAlign: TextAlign.center),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔻 Tipo
              const Text(
                'Seleciona o Tipo de Questão',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _tipoSelecionado,
                    hint: const Center(child: Text('Escolhe o tipo')),
                    onChanged: (int? novoValor) {
                      setState(() {
                        _tipoSelecionado = novoValor;
                      });
                    },
                    items: tipo.entries.map<DropdownMenuItem<int>>((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(entry.value, textAlign: TextAlign.center),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_nivelSelecionado != null && _tipoSelecionado != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionsPage(
                            nivelSelecionado: _nivelSelecionado!,
                            tipoSelecionado: _tipoSelecionado!,
                            // Se quiseres passar também o nome:
                            // nomeUtilizador: widget.nomeUtilizador,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
