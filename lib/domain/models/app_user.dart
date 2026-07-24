/// Modelo que representa um utilizador da aplicação.
class AppUser {
  // Identificador único do utilizador.
  final String uid;

  // Nome de utilizador.
  final String username;

  // Email da conta.
  final String email;

  const AppUser({
    required this.uid,
    required this.username,
    required this.email,
  });

  // Cria um AppUser a partir dos dados do Firestore.
  factory AppUser.fromMap(
    Map<String, dynamic> data,
    String uid,
  ) {
    return AppUser(
      uid: uid,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
    );
  }

  // Converte o objeto para guardar no Firestore.
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
    };
  }

  // Cria uma cópia alterando apenas os campos necessários.
  AppUser copyWith({
    String? username,
    String? email,
  }) {
    return AppUser(
      uid: uid,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'AppUser(uid: $uid, username: $username, email: $email)';
  }
}