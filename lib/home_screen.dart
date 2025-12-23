import 'package:flutter/material.dart';
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
              // No need to navigate manually; AuthGate will handle it
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
