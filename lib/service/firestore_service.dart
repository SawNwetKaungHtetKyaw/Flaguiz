import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaguiz/utils/utils.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'users';

  Future<void> createOrUpdateUser(UserModel user) async {
    if (user.id == null) return;
    Utils.printLog('✅===> Create or Update User To Firebase ${user.id}');
    await _firestore.collection(collection).doc(user.id).set(user.toJson());
  }

  Future<UserModel?> getUser(String uid) async {
    Utils.printLog('✅===> Get User From Firebase');
    final doc = await _firestore.collection(collection).doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }

  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  Future<bool> checkIdExists(String playerID) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .where('player_id', isEqualTo: playerID)
        .limit(1)
        .get();

    return doc.docs.isNotEmpty;
  }

  /// Search Friend
  Future<UserModel?> searchByCustomId(String playerID) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .where('player_id', isEqualTo: playerID)
        .limit(1)
        .get();

    if (doc.docs.isEmpty) return null;
    return UserModel.fromJson(doc.docs.first.data());
  }
}
