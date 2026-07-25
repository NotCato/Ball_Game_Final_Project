import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'firebase_options.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Obriga a aplicação a funcionar apenas em modo horizontal.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const TiltMazeApp());
}

class TiltMazeApp extends StatefulWidget {
  const TiltMazeApp({super.key});

  @override
  State<TiltMazeApp> createState() => _TiltMazeAppState();
}

class _TiltMazeAppState extends State<TiltMazeApp> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tilt Maze',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Enquanto verifica se existe uma sessão iniciada.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Se existir um utilizador autenticado, abre o menu.
          if (snapshot.hasData) {
            return const MainMenu();
          }

          // Caso contrário, apresenta o ecrã de login.
          return const LoginScreen();
        },
      ),
    );
  }
}