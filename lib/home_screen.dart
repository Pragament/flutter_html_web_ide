import 'package:flutter/material.dart';
import 'package:flutter_html_web_ide/auth/login_screen.dart';
import 'auth/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome ${user?.email ?? 'User'}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
