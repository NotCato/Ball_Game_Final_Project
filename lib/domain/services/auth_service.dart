import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  /// Instância do Firebase Authentication utilizada pela aplicação.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Obtém o utilizador atualmente autenticado.
  User? get currentUser => _auth.currentUser;

  /// Verifica se existe uma sessão ativa.
  bool get isLoggedIn => currentUser != null;

  /// Regista um novo utilizador com email e password no entanto a password não é armazenada no Firebase Authentication, apenas o email e o username são guardados.
  Future<UserCredential> register({
    required String username,
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Inicia sessão utilizando email e password.
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Termina a sessão do utilizador atualmente autenticado.
  Future<void> logout() async {
    await _auth.signOut();
  }
}