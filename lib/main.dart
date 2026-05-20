import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/app_widget.dart';

void main() async {
  // 1. Garante que os canais nativos do Flutter estão prontos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o Firebase com as configurações geradas para sua plataforma
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Roda o aplicativo
  runApp(const StudyMapApp());
}