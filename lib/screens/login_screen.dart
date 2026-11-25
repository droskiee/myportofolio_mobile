import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      await context.read<AuthState>().login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.message)));
      setState(() => _isSubmitting = false);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const parchment = Color(0xFFE8D5AC);
    const gold = Color(0xFFD8B779);

    return Scaffold(
      backgroundColor: const Color(0xFF10100F),
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFF171612),
        foregroundColor: gold,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter your portfolio account to continue.',
                    style: TextStyle(color: parchment, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    style: const TextStyle(color: parchment),
                    decoration: _decoration('Username'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter your username.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    style: const TextStyle(color: parchment),
                    decoration: _decoration('Password'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter your password.'
                        : null,
                    onFieldSubmitted: (_) => _isSubmitting ? null : _login(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF183D28),
                      foregroundColor: parchment,
                      side: const BorderSide(color: gold, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: parchment,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFFD8B779)),
    filled: true,
    fillColor: const Color(0xFF171612),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF9C8150)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD8B779), width: 2),
    ),
  );
}
