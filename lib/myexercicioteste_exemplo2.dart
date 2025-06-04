import 'package:flutter/material.dart';
import 'database_helper.dart';

Widget buildWidgetList() {
  return const Scaffold(
    body: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("List")],
        ),
      ),
    ),
  );
}
