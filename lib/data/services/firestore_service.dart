import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/app_user.dart';

/// Serviço responsável pelas operações no Firestore.
class FirestoreService {
  // Instância do Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cria um documento para o utilizador.
  Future<void> createUser(AppUser user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toMap());
  }

  // Obtém os dados do utilizador.
  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return AppUser.fromMap(doc.data()!, doc.id);
  }
}