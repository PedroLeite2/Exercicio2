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
            child: Column(
              children: [
                const SizedBox(height: 60),
                
                // Title with the same style as other pages
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
                  child: const Text(
                    "Top Scores",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Leaderboard card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white.withOpacity(0.85),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _topScores.length,
                      itemBuilder: (context, index) {
                        final user = _topScores[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.amber.shade600,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              user['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              '${user['score']} pontos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _paginaLogin,
                    style: _buttonStyle(),
                    child: const Text("Quer participar? Faça login!"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInScreen(String username, int score) {
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
            child: Column(
              children: [
                const SizedBox(height: 60),
                
                // User info card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white.withOpacity(0.85),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        username,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Score: $score pontos',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Leaderboard title
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
                  child: const Text(
                    "Leaderboard",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Leaderboard card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white.withOpacity(0.85),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _topScores.length,
                      itemBuilder: (context, index) {
                        final user = _topScores[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.amber.shade600,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              user['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              '${user['score']} pontos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        );
                      },
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

  @override
  Widget build(BuildContext context) {
    return _userName == null
        ? _buildNotLoggedInScreen(_topScores)
        : _buildLoggedInScreen(_userName!, _score);
  }
}