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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = "";

  void _register() async {
    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();
    if (name.isEmpty || password.isEmpty) return;
    await DatabaseHelper.instance.registerUser(name, password);
    setState(() => _message = "User '$name' registered.");
    _nameController.clear();
    _passwordController.clear();
  }

  void _login() async {
    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();
    if (name.isEmpty || password.isEmpty) return;
    bool success = await DatabaseHelper.instance.loginUser(name, password);
    setState(
      () => _message = success ? "Login successful!" : "Invalid credentials.",
    );
    if (success) {
      _nameController.clear();
      _passwordController.clear();
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfigureQuestionsPage(nomeUtilizador: name),
      ),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login / Register", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: const Text("Login")),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _register,
                child: const Text("Register"),
              ),
              const SizedBox(height: 20),
              Text(_message, style: const TextStyle(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}
