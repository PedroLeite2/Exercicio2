import 'package:avaliacaoex2/main.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'configure_questions_widget.dart';
import 'package:another_flushbar/flushbar.dart';

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
  bool rememberMe = false;
  bool isThereAnUser = true;
  String username = "";

  void onChanged(bool? value) {
    setState(() {
      rememberMe = value ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyLoggedIn();
  }

  Future<void> _checkIfAlreadyLoggedIn() async {
    final user = await DatabaseHelper.instance.getLoggedUser();
    if (user != null) {
      setState(() {
        username = user;
        isThereAnUser = true;
      });
    } else {
      setState(() {
        isThereAnUser = false;
      });
    }
  }

  void _login() async {
    if (_formKey.currentState?.validate() != true) return;

    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();
    bool success = await DatabaseHelper.instance.loginUser(name, password);

    if (success) {
      await DatabaseHelper.instance.saveLoggedUser(name);
      bottomNavIndexNotifier.value = 1;
      _nameController.clear();
      _passwordController.clear();
      _paginaConfigurarQuestoes(name);
    } else {
      Flushbar(
        messageText: Text(
          "Username ou password incorretos.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 231, 161, 145),
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(8),
      ).show(context);
      _nameController.clear();
      _passwordController.clear();
    }
  }

  void _paginaConfigurarQuestoes(String name) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => ConfigureQuestionsPage()));
  }

  void _paginaRegisto() {
    Navigator.of(context).pushNamed('/register');
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

  Widget screenNotLoggedIn() {
    return Scaffold(
      body: Stack(
        children: [
          // Background image changed to redes.png
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/redes.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay for better readability
          Container(color: Colors.black.withOpacity(0.2)),

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

                      // Enhanced "Bem Vindo" title
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
                          "Bem Vindo",
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
                      Theme(
                        data: Theme.of(context).copyWith(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: CheckboxListTile(
                              value: rememberMe,
                              onChanged: onChanged,
                              title: const Text(
                                "Lembrar-me",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.amber.shade600,
                              checkColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Não tem conta?",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: _paginaRegisto,
                              child: const Text(
                                "Registe-se",
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
                          onPressed: _login,
                          style: _buttonStyle(),
                          child: const Text("Login"),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.white.withOpacity(0.3),
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            'ou',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.white.withOpacity(0.3),
                              indent: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/google.png',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Login com Google',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/microsoft.png',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Login com Microsoft',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Widget screenLoggedIn(String userName) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/redes.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bem-vindo, $userName!",
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black54,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        bottomNavIndexNotifier.value = 1;
                        Navigator.of(
                          context,
                        ).pushNamed('/buildWidgetConfigureQuestions');
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade600,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.3),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text("Começar Jogo"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        DatabaseHelper.instance.logoutUser();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.3),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isThereAnUser ? screenLoggedIn(username) : screenNotLoggedIn();
  }
}
