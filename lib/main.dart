import 'package:flutter/material.dart';
import 'package:avaliacaoex2/myexercicioteste_exemplo1.dart';
import 'package:avaliacaoex2/buildWidgetConfigureQuestions.dart';
import 'package:avaliacaoex2/myexercicioteste_exemplo3.dart';
import 'registarScreen.dart';
import 'database_helper.dart';

final ValueNotifier<int> bottomNavIndexNotifier = ValueNotifier<int>(0);
final ValueNotifier<int> _selectedIndex = bottomNavIndexNotifier;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DatabaseHelper.instance.database;
  } catch (e) {
    print('DB init error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
      home: const MyExercicioTeste(title: 'Redes & Companhia'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyExercicioTeste extends StatefulWidget {
  final String title;
  const MyExercicioTeste({super.key, required this.title});

  @override
  State<MyExercicioTeste> createState() => _MyExercicioTesteState();
}

class _MyExercicioTesteState extends State<MyExercicioTeste> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String? _nomeUtilizador;

  void _onItemTapped(int index) {
    if (index == _selectedIndex.value) {
      _navigatorKey.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex.value = index;
      });

      final routeName = _routeName(index);
      final args = (routeName == '/buildWidgetConfigureQuestions')
          ? _nomeUtilizador
          : null;

      _navigatorKey.currentState?.pushReplacementNamed(
        routeName,
        arguments: args,
      );
    }
  }

  String _routeName(int index) {
    switch (index) {
      case 0:
        return '/login';
      case 1:
        return '/buildWidgetConfigureQuestions';
      case 2:
        return '/score';
      default:
        return '/login';
    }
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => buildWidgetLogin());
      case '/buildWidgetConfigureQuestions':
        final name = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => buildWidgetConfigureQuestions(userName: name),
        );

      case '/score':
        return MaterialPageRoute(builder: (_) => buildWidgetSettings());
      case '/register': // your extra page
        return MaterialPageRoute(builder: (_) => Registar());
      default:
        return MaterialPageRoute(builder: (_) => buildWidgetLogin());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorKey.currentState?.pushReplacementNamed(
        _routeName(_selectedIndex.value),
        arguments: _nomeUtilizador,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Navigator(key: _navigatorKey, onGenerateRoute: _onGenerateRoute),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, value, _) {
          return BottomNavigationBar(
            currentIndex: value,
            selectedItemColor: const Color.fromARGB(255, 68, 91, 166),
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Login/Register',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Questions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Score',
              ),
            ],
          );
        },
      ),
    );
  }
}
