/// Modelo que representa um utilizador da aplicação.
class AppUser {
  // Identificador único do utilizador.
  final String uid;

  // Nome de utilizador.
  final String username;

  // Email da conta.
  final String email;

  // Melhores tempos por nível.
  final Map<String, dynamic> bestTimes;

  const AppUser({
    required this.uid,
    required this.username,
    required this.email,
    this.bestTimes = const {},
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
      bestTimes: Map<String, dynamic>.from(
        data['bestTimes'] ?? {},
      ),
    );
  }

  // Converte o objeto para guardar no Firestore.
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'bestTimes': bestTimes,
    };
  }

  // Cria uma cópia alterando apenas os campos necessários.
  AppUser copyWith({
    String? username,
    String? email,
    Map<String, dynamic>? bestTimes,
  }) {
    return AppUser(
      uid: uid,
      username: username ?? this.username,
      email: email ?? this.email,
      bestTimes: bestTimes ?? this.bestTimes,
    );
  }

  @override
  String toString() {
    return 'AppUser(uid: $uid, username: $username, email: $email, bestTimes: $bestTimes)';
  }
}