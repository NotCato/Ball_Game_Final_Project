import 'package:flutter/material.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/firestore_service.dart';
import '../../data/models/app_user.dart';
import 'menu.dart';

/// Ecrã de registo.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Serviços utilizados no registo.
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  // Controladores dos campos.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Indica se o registo está em processamento.
  bool _isLoading = false;

  // Efetua o registo do utilizador.
  Future<void> _register() async {
    // Verifica se todos os campos foram preenchidos.
    if (_usernameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preenche todos os campos."),
        ),
      );
      return;
    }

    // Verifica se as passwords coincidem.
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("As passwords não coincidem."),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Cria a conta no Firebase Authentication.
      final credential = await _authService.register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Guarda os dados do utilizador no Firestore.
      final user = AppUser(
        uid: credential.user!.uid,
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
      );

      await _firestoreService.createUser(user);

      if (!mounted) return;

      // Registo concluído com sucesso.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainMenu(),
        ),
        (route) => false,
      );
    } catch (e) {
      // Apresenta uma mensagem caso ocorra um erro.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao criar conta.\n$e"),
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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "CRIAR CONTA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Campo de username.
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Campo de email.
                  TextField(
                    controller: _emailController,
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

                  const SizedBox(height: 20),

                  // Campo de confirmação da password.
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirmar Password",
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botão de registo.
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Criar Conta"),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Volta ao ecrã de login.
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Já tens conta? Inicia sessão",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}