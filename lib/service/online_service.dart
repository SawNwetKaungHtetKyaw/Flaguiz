import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaguiz/service/auth_service.dart';

class OnlineService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  Future<void> setOnline(String? uid) async {
    if (_auth.currentUser != null) {
      await _firestore.collection("users").doc(uid).update({
        "is_online": true,
        "last_seen": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> setOffline(String? uid) async {
    if (_auth.currentUser != null) {
      await _firestore.collection("users").doc(uid).update({
        "is_online": false,
        "last_seen": FieldValue.serverTimestamp(),
      });
    }
  }
}
