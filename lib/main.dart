import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// --- YENİ EKLENEN FİREBASE KÜTÜPHANELERİ ---
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// -------------------------------------------

import 'src/app/bukombin_app.dart';
import 'src/state/app_state.dart';

Future<void> main() async {
  // Flutter'ın arka planını hazırlıyoruz (zaten sende vardı)
  WidgetsFlutterBinding.ensureInitialized();

  // --- YENİ EKLENEN FİREBASE BAŞLATMA KODU ---
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // -------------------------------------------

  // Senin kendi ayarların
  await dotenv.load(fileName: ".env");

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