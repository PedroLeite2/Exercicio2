import 'package:flutter/material.dart';
import 'database_helper.dart';

Widget buildWidgetSettings() {
  return const SettingsPage();
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _ScorePageState();
}

class _ScorePageState extends State<SettingsPage> {
  int _score = 0;
  final String _userName = 'pedro'; // Example name

  Future<void> _getScore() async {
    final db = DatabaseHelper.instance; // Replace with your DB class
    final score = await db.getUserScore(_userName);
    setState(() {
      _score = score ?? 0;
    });
  }

  Future<void> _addScore() async {
    final db = DatabaseHelper.instance;
    final currentScore = await db.getUserScore(_userName) ?? 0;
    final newScore = currentScore + 1;
    await db.updateUserScore(_userName, newScore);
    setState(() {
      _score = newScore;
    });
  }

  @override
  void initState() {
    super.initState();
    _getScore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Score Manager")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Score", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text('$_score', style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _addScore, child: const Text('Add +1')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getScore,
              child: const Text('Get Score'),
            ),
          ],
        ),
      ),
    );
  }
}
