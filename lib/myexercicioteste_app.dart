import 'package:flutter/material.dart';
import 'package:avaliacaoex2/myexercicioteste_exemplo1.dart';
import 'package:avaliacaoex2/myexercicioteste_exemplo2.dart';
import 'package:avaliacaoex2/myexercicioteste_exemplo3.dart';

class MyExercicioTeste extends StatefulWidget {
  final String title;
  const MyExercicioTeste({super.key, required this.title});
  @override
  State<MyExercicioTeste> createState() => _MyExercicioTesteState();
}

class _MyExercicioTesteState extends State<MyExercicioTeste> {
  int _selectedIndex = 0;
  late final List<Widget> _screenOptions;
  @override
  void initState() {
    super.initState();
    _screenOptions = [
      buildWidgetLogin(),
      buildWidgetList(),
      buildWidgetSettings(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: IndexedStack(index: _selectedIndex, children: _screenOptions),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 68, 91, 166),
        onTap: _onItemTapped,
      ),
    );
  }
}
