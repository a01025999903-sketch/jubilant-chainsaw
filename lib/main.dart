import 'package:flutter/material.dart';

void main() {
  runApp(const PostHunterApp());
}

class PostHunterApp extends StatelessWidget {
  const PostHunterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'صائد البوستات',
      theme: ThemeData.dark(useMaterial3: true),
      home: const Scaffold(
        body: Center(
          child: Text(
            'صائد البوستات\n\nلقط البوست المطلوب بسرعة',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
