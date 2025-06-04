import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'myexercicioteste_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // A instância da base de dados é criada antes de iniciar a app
  await DatabaseHelper.instance.database;
  runApp(const ExercicioTeste());
}

class ExercicioTeste extends StatelessWidget {
  const ExercicioTeste({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExercicioTeste',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 68, 91, 166),
        ),
        useMaterial3: true,
      ),
      home: const MyExercicioTeste(title: 'MyExercicioTeste'),
    );
  }
}
