import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_controller.dart';
import 'register_screen.dart';
import 'forgot_screen.dart';
import '../home_screen.dart';
import '../services/session_service.dart';

class LoginScreen extends StatelessWidget {
  final bool openedFromIDE;

  const LoginScreen({super.key, this.openedFromIDE = false});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LoginController>();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

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
                'HTML Web IDE',
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
                label: 'Username',
                hint: 'Username',
              ),
              const SizedBox(height: 12),

              _inputField(
                controller: passwordCtrl,
                label: 'Password',
                obscure: true,
              ),
              const SizedBox(height: 12),

              _inputField(
                controller: phoneCtrl,
                label: 'Last 6 digits of phone number',
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotScreen()),
                  );
                },
                child: const Text(
                  'Forgot username / password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),

              const SizedBox(height: 5),

              if (controller.error != null)
                Text(
                  "Invalid Credentials",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),

              const SizedBox(height: 16),

              // Login Button
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
                            username: emailCtrl.text.trim(),
                            password: passwordCtrl.text,
                            phoneLast6: phoneCtrl.text.trim(),
                          );

                          if (success && context.mounted) {
                            if (Navigator.canPop(context)) {
                              // Login opened from IDE (top-bar)
                              Navigator.pop(context);
                            } else {
                              // Initial login / save-to-cloud login
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
                            }
                          }
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

              const SizedBox(height: 10),

              // Guest Login Button
              TextButton(
                onPressed: () {
                  SessionService.loginAsGuest();

                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  }
                },
                child: const Text(
                  'Skip login (Continue as Guest)',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 16),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
