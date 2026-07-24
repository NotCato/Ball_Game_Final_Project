import 'package:flutter/material.dart';

import '../../data/services/auth_service.dart';
import 'menu.dart';
import 'register_screen.dart';

/// Ecrã de autenticação.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Serviço de autenticação.
  final AuthService _authService = AuthService();

  // Controladores dos campos de texto.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Indica se o login está em processamento.
  bool _isLoading = false;

  // Efetua o login do utilizador.
  Future<void> _login() async {
    // Verifica se todos os campos foram preenchidos.
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preenche todos os campos."),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Tenta autenticar o utilizador.
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      // Login efetuado com sucesso.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainMenu(),
        ),
      );
    } catch (e) {
      // Apresenta uma mensagem caso ocorra um erro.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao iniciar sessão.\n$e"),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Liberta os controladores da memória.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "TILT MAZE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Inicia sessão para continuar",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 40),

              // Campo de email.
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),

              const SizedBox(height: 20),

              // Campo de password.
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),

              const SizedBox(height: 30),

              // Botão para iniciar sessão.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Entrar",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Navega para o ecrã de registo.
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Não tens conta? Regista-te",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}