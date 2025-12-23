import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LoginController>();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF252526),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Flutter Web IDE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              _inputField(
                controller: emailCtrl,
                label: 'Email or Username',
                hint: 'email@example.com or username',
              ),
              const SizedBox(height: 12),

              _inputField(
                controller: passwordCtrl,
                label: 'Password',
                obscure: true,
              ),

              const SizedBox(height: 16),

              if (controller.error != null)
                Text(
                  "Invalid Credentials",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),

              const SizedBox(height: 16),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E639C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed:
                    controller.isLoading
                        ? null
                        : () async {
                          final success = await controller.login(
                            emailCtrl.text,
                            passwordCtrl.text,
                          );

                          // Do nothing — AuthGate will auto-redirect
                        },
                child:
                    controller.isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
