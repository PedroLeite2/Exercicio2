import 'package:flutter/material.dart';
import 'database_helper.dart';

Widget buildWidgetAdd() {
  return const Scaffold(
    body: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Add")],
        ),
      ),
    ),
  );
}
