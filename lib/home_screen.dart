import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'ide_screen.dart';
import 'services/session_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTML Web IDE'),
        actions: [
          // LOGIN
          TextButton(
            onPressed: () async {
              await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
              // IMPORTANT: do nothing here
              // HomeScreen + IDE are already mounted
            },
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),

          // LOGOUT
          TextButton(
            onPressed: () {
              SessionService.logout();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: const IDEScreen(),
    );
  }
}
