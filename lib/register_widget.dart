import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:avaliacaoex2/login_widget.dart';
import 'package:another_flushbar/flushbar.dart';
import 'main.dart';

class Registar extends StatefulWidget {
  const Registar({super.key});

  @override
  State<Registar> createState() => _RegistarState();
}

class _RegistarState extends State<Registar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  String _message = "";

  void _register() async {
    if (_formKey.currentState?.validate() != true) return;

    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();
    await DatabaseHelper.instance.registerUser(name, password);

    _nameController.clear();
    _passwordController.clear();
    _repeatPasswordController.clear();
    _paginaLogin();

    Flushbar(
      messageText: Text(
        "Utilizador $name registrado com sucesso.",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
      backgroundColor: const Color.fromARGB(255, 195, 199, 234),
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  void _paginaLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.amber.shade600,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/redes.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay for better readability
          Container(color: Colors.black.withOpacity(0.3)),

          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Form(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      // Title with the same style as login page
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "Registo",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Username'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor insira o seu username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: _inputDecoration('Password'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor insira a sua password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _repeatPasswordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: _inputDecoration('Repita a Password'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor insira uma password válida';
                          }
                          if (value != _passwordController.text) {
                            return 'As passwords não coincidem';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Já tem conta?",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: _paginaLogin,
                              child: const Text(
                                "Faça Login Aqui",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: _buttonStyle(),
                          child: const Text("Registar"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _message,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
