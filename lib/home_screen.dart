import 'package:flutter/material.dart';
import 'ide_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
