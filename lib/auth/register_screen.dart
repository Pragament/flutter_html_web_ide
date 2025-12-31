import 'package:flutter/material.dart';
import '../services/register_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _phoneLast6Ctrl = TextEditingController();
  final _birthDayCtrl = TextEditingController();

  bool _isLoading = false;
  String? _error;

  Future<void> _register() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await RegisterService.registerUser(
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text,
        confirmPassword: _confirmPasswordCtrl.text,
        phoneLast6: _phoneLast6Ctrl.text.trim(),
        birthDay: int.parse(_birthDayCtrl.text.trim()),
      );

      if (!mounted) return;

      // Go back to Login screen
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _phoneLast6Ctrl.dispose();
    _birthDayCtrl.dispose();
    super.dispose();
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                _inputField(
                  controller: _usernameCtrl,
                  label: 'Username',
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Username required'
                              : null,
                ),

                const SizedBox(height: 12),

                _inputField(
                  controller: _passwordCtrl,
                  label: 'New Password',
                  obscure: true,
                  validator:
                      (v) =>
                          v == null || v.length < 6
                              ? 'Minimum 6 characters'
                              : null,
                ),

                const SizedBox(height: 12),

                _inputField(
                  controller: _confirmPasswordCtrl,
                  label: 'Confirm Password',
                  obscure: true,
                  validator:
                      (v) =>
                          v != _passwordCtrl.text
                              ? 'Passwords do not match'
                              : null,
                ),

                const SizedBox(height: 12),

                _inputField(
                  controller: _phoneLast6Ctrl,
                  label: 'Last 6 digits of phone number',
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator:
                      (v) =>
                          v == null || v.length != 6
                              ? 'Enter exactly 6 digits'
                              : null,
                ),

                const SizedBox(height: 12),

                _inputField(
                  controller: _birthDayCtrl,
                  label: 'Birth Day (1–31)',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final day = int.tryParse(v ?? '');
                    if (day == null || day < 1 || day > 31) {
                      return 'Invalid day';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                if (_error != null)
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  ),

                const SizedBox(height: 16),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E639C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _isLoading ? null : _register,
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text('Register'),
                ),

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
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
