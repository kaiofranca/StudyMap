import 'package:flutter/material.dart';

class StudyMapApp extends StatelessWidget {
  const StudyMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyMap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4), // Cor roxa base
          brightness: Brightness.dark, // Tema escuro conforme os wireframes
        ),
        useMaterial3: true,
      ),
      // Temporariamente, mostramos uma tela simples para testar
      home: const Scaffold(
        body: Center(
          child: Text('StudyMap: Firebase Conectado!'),
        ),
      ),
    );
  }
}