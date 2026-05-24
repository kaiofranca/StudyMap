import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/gradient_button.dart';
import 'auth_controller.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2023),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x4400EEFC), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00EEFC).withValues(alpha: 0.25),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.explore_outlined,
                  color: Color(0xFF00EEFC),
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'StudyMap',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            if (authController.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              GradientButton(
                label: 'Entrar',
                onPressed: () async {
                  try {
                    await authController.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao entrar: $e')),
                      );
                    }
                  }
                },
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: authController.isLoading
                  ? null
                  : () async {
                      try {
                        await authController.loginWithGoogle();
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao entrar com Google: $e')),
                          );
                        }
                      }
                    },
              icon: const Icon(Icons.account_circle_outlined, size: 20),
              label: const Text('Continuar com o Google'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE2E2E7),
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: Color(0x33FFFFFF), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color(0xFF1E2023),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: const Text('Não tem uma conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}
