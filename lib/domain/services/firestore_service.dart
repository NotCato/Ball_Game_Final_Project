import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/app_user.dart';

/// Serviço responsável pelas operações no Firestore.
class FirestoreService {
  // Instância do Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cria um documento para o utilizador.
  Future<void> createUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  // Obtém os dados do utilizador.
  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return AppUser.fromMap(doc.data()!, doc.id);
  }

  // Guarda o melhor tempo de um nível.
  Future<void> saveBestTime({
    required String uid,
    required int level,
    required double time,
  }) async {
    try {
      print("========== SAVE BEST TIME ==========");
      print("UID: $uid");
      print("Level: $level");
      print("Time: $time");

      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        print("ERRO: Documento do utilizador não existe.");
        return;
      }

      final data = doc.data();

      Map<String, dynamic> bestTimes = {};

      if (data != null && data['bestTimes'] != null) {
        bestTimes = Map<String, dynamic>.from(data['bestTimes']);
      }

      final key = 'level_$level';

      if (!bestTimes.containsKey(key) ||
          time < (bestTimes[key] as num).toDouble()) {
        bestTimes[key] = time;

        await _firestore.collection('users').doc(uid).update({
          'bestTimes': bestTimes,
        });

        print("Recorde atualizado!");
      } else {
        print("O recorde já era melhor.");
      }

      print("====================================");
    } catch (e) {
      print("ERRO AO GUARDAR O TEMPO:");
      print(e);
    }
  }

  // Obtém todos os melhores tempos.
  Future<Map<String, dynamic>> getBestTimes(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        return {};
      }

      final data = doc.data()!;

      if (data['bestTimes'] == null) {
        return {};
      }

      return Map<String, dynamic>.from(data['bestTimes']);
    } catch (e) {
      print("ERRO AO LER OS TEMPOS:");
      print(e);
      return {};
    }
  }
}