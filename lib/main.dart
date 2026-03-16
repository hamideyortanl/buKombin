import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// --- YENİ EKLENEN FİREBASE KÜTÜPHANELERİ ---
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// -------------------------------------------

import 'src/app/bukombin_app.dart';
import 'src/services/notification_service.dart';
import 'src/state/app_state.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  await NotificationService.instance.init();

  final appState = AppState();
  await appState.init();

  // Uygulamayı çalıştırıyoruz
  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const BuKombinApp(),
    ),
  );
}