import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TrafficLightStaticPage(),
    );
  }
}

class TrafficLightStaticPage extends StatelessWidget {
  const TrafficLightStaticPage({super.key});

  Widget _buildLight(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              // แสดงไฟจราจรนิ่ง
              _StaticLight(color: Colors.red),
              _StaticLight(color: Colors.yellow),
              _StaticLight(color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaticLight extends StatelessWidget {
  final Color color;

  const _StaticLight({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}