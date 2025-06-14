import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'main.dart';

Widget buildWidgetSettings() {
  return const SettingsPage();
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Map<String, dynamic>> _topScores = [];
  String? _userName;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _checkLoginAndLoadScore();
  }

  void _paginaLogin() {
    bottomNavIndexNotifier.value = 0;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 191, 206, 232),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Future<void> _checkLoginAndLoadScore() async {
    final user = await DatabaseHelper.instance.getLoggedUser();
    final topScores = await DatabaseHelper.instance.getTop5Scores();
    if (user != null) {
      final score = await DatabaseHelper.instance.getUserScore(user);
      setState(() {
        _userName = user;
        _score = score ?? 0;
        _topScores = topScores;
      });
    } else {
      setState(() {
        _userName = null;
        _topScores = topScores;
      });
    }
  }

  Widget _buildNotLoggedInScreen(List<Map<String, dynamic>> topScores) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color.fromARGB(255, 212, 208, 203),
                Color.fromARGB(255, 81, 30, 233),
                Color.fromARGB(255, 225, 0, 255),
              ],
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: const Text(
              "Top Scores",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
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
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
              itemCount: _topScores.length,
              itemBuilder: (context, index) {
                final user = _topScores[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(
                      user['name'],
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      '${user['score']} pontos',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.80,
            child: ElevatedButton(
              onPressed: _paginaLogin,
              style: _buttonStyle(),
              child: const Text("Quer participar? Faça login!"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInScreen(String username, int score) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Score: $score pontos',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 40),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color.fromARGB(255, 212, 208, 203),
                Color.fromARGB(255, 81, 30, 233),
                Color.fromARGB(255, 225, 0, 255),
              ],
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: const Text(
              "Leaderboard",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
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
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
              itemCount: _topScores.length,
              itemBuilder: (context, index) {
                final user = _topScores[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(
                      user['name'],
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      '${user['score']} pontos',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _userName == null
        ? _buildNotLoggedInScreen(_topScores)
        : _buildLoggedInScreen(_userName!, _score);
  }
}
