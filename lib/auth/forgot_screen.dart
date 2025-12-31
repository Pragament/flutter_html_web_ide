import 'package:flutter/material.dart';
import '../services/forgot_service.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _phoneCtrl = TextEditingController();
  final _birthDayCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();

  String? _username;
  String? _error;
  bool _loading = false;
  bool _resetMode = false;

  Future<void> _findAccount() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final username = await ForgotService.findUsername(
        phoneLast6: _phoneCtrl.text.trim(),
        birthDay: int.parse(_birthDayCtrl.text.trim()),
      );

      setState(() {
        _username = username;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _resetPassword() async {
    try {
      await ForgotService.resetPassword(
        username: _username!,
        newPassword: _newPasswordCtrl.text,
        phoneLast6: _phoneCtrl.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context); // Back to login
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Forgot Username / Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              _inputField(
                controller: _phoneCtrl,
                label: 'Last 6 digits of phone number',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              _inputField(
                controller: _birthDayCtrl,
                label: 'Birth Day (1–31)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              if (_username == null)
                ElevatedButton(
                  onPressed: _loading ? null : _findAccount,
                  child: const Text(
                    'Find Account',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),

              if (_username != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Username: $_username',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    setState(() {
                      _resetMode = !_resetMode;
                    });
                  },
                  child: Text(
                    _resetMode
                        ? 'Cancel Password Reset'
                        : 'Reset Password Instead?',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),

                if (_resetMode) ...[
                  const SizedBox(height: 12),
                  _inputField(
                    controller: _newPasswordCtrl,
                    label: 'New Password',
                    obscure: true,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _resetPassword,
                    child: const Text(
                      'Update Password',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ],

              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Please enter password!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ],

              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Back to Login',
                  style: TextStyle(color: Colors.blue),
                ),
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
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
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
