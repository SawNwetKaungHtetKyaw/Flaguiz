import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setOnline(String uid) async {
    await _firestore.collection("users").doc(uid).update({
      "is_online": true,
      "last_seen": FieldValue.serverTimestamp(),
    });
  }

  Future<void> setOffline(String uid) async {
    await _firestore.collection("users").doc(uid).update({
      "is_online": false,
      "last_seen": FieldValue.serverTimestamp(),
    });
  }
}