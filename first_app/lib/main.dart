import 'package:flutter/material.dart';
import 'AssignmentWeek5.dart'; // import ไฟล์ที่มี ApiExampleList อยู่

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // เอาแถบ debug ออก
      title: 'Flutter API Demo',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const Assignmentweek5(),
    );
  }
}