import 'package:flutter/material.dart';
import 'package:avaliacaoex2/myexercicioteste_exemplo1.dart';
import 'package:avaliacaoex2/buildWidgetConfigureQuestions.dart';
import 'package:avaliacaoex2/myexercicioteste_exemplo3.dart';
import 'registarScreen.dart';

class MyExercicioTeste extends StatefulWidget {
  final String title;
  const MyExercicioTeste({super.key, required this.title});

  @override
  State<MyExercicioTeste> createState() => _MyExercicioTesteState();
}

class _MyExercicioTesteState extends State<MyExercicioTeste> {
  int _selectedIndex = 0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // Optional: pop to first route on tab re-tap
      _navigatorKey.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
      _navigatorKey.currentState?.pushReplacementNamed(
        _routeName(_selectedIndex),
      );
    }
  }

  String _routeName(int index) {
    switch (index) {
      case 0:
        return '/login';
      case 1:
        return '/questions';
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
      case '/questions':
        return MaterialPageRoute(
          builder: (_) => buildWidgetConfigureQuestions(),
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
    // start with initial route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorKey.currentState?.pushReplacementNamed(
        _routeName(_selectedIndex),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Navigator(key: _navigatorKey, onGenerateRoute: _onGenerateRoute),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 68, 91, 166),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Login/Register',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Questions'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Score'),
        ],
      ),
    );
  }
}
