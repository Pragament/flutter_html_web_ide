import 'package:flutter/material.dart';
import 'package:flutter_html_web_ide/auth/login_screen.dart';
import 'package:flutter_html_web_ide/ide_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'auth/auth_service.dart';
import 'auth/login_controller.dart';
import 'auth/register_controller.dart';
import 'auth/forgot_credentials_screen.dart';
import 'home_screen.dart';
import 'auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FlutterHtmlWebIDE());
}

class FlutterHtmlWebIDE extends StatelessWidget {
  const FlutterHtmlWebIDE({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => RegisterController()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordController()),
      ],
      child: MaterialApp(
        title: 'HTML Web IDE',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: const AuthGate(),
        debugShowCheckedModeBanner: false,
        //initialRoute: '/login',
        /*routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },*/
      ),
    );
  }
}
