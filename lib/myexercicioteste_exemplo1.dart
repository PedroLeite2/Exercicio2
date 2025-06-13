import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'buildWidgetConfigureQuestions.dart';

Widget buildWidgetLogin() {
  return const LoginRegisterPage();
}

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = "";
  bool rememberMe = false;

  void onChanged(bool? value) {
    setState(() {
      rememberMe = value ?? false;
    });
  }

  void _login() async {
    if (_formKey.currentState?.validate() != true) return;

    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();
    bool success = await DatabaseHelper.instance.loginUser(name, password);
    setState(
      () => _message = success ? "Login successful!" : "Invalid credentials.",
    );
    if (success) {
      _nameController.clear();
      _passwordController.clear();
      _paginaConfigurarQuestoes(name);
    }
  }

  void _paginaConfigurarQuestoes(String nome) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConfigureQuestionsPage(nomeUtilizador: nome),
      ),
    );
  }

  void _paginaRegisto() {
    Navigator.of(context).pushNamed('/register');
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 191, 206, 232),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
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
                  const SizedBox(height: 40),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 39, 169, 176),
                            Color.fromARGB(255, 81, 30, 233),
                            Color.fromARGB(255, 225, 0, 255),
                          ],
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    child: const Text(
                      "Bem Vindo",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors
                            .white, // Obrigatório para o ShaderMask funcionar
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Username'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration('Password'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  CheckboxListTile(
                    value: rememberMe,
                    onChanged: onChanged,
                    title: const Text("Remember Me"),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Não tem conta?",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: _paginaRegisto,
                        child: const Text(
                          "Registe-se",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: _buttonStyle(),
                      child: const Text("Login"),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          endIndent: 10,
                        ),
                      ),
                      const Text(
                        'ou',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          indent: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, // make button full width
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, // keep content minimal width
                        mainAxisAlignment: MainAxisAlignment
                            .center, // center icon + text horizontally
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            height: 28,
                            width: 28,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Login com Google',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity, // make button full width
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, // keep content minimal width
                        mainAxisAlignment: MainAxisAlignment
                            .center, // center icon + text horizontally
                        children: [
                          Image.asset(
                            'assets/images/microsoft.png',
                            height: 28,
                            width: 28,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Login com Microsoft',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Text(
                    _message,
                    style: const TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
