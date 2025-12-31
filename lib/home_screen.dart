import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'ide_screen.dart';
import 'services/session_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated = SessionService.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HTML Web IDE'),
        actions: [
          // LOGIN (guest or logged out)
          if (!isAuthenticated)
            TextButton(
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );

                // 🔴 THIS IS THE KEY
                if (result == true && mounted) {
                  setState(() {});
                }
              },
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),

          // LOGOUT (real login only)
          if (isAuthenticated)
            TextButton(
              onPressed: () {
                SessionService.logout();

                setState(() {});

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),

          const SizedBox(width: 8),
        ],
      ),
      body: IDEScreen(
        onLoginSuccess: () {
          if (mounted) {
            setState(() {});
          }
        },
      ),
    );
  }
}
