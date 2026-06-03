// services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaguiz/models/battle_room_model.dart';

class BattleFirestoreService {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference battleRooms = firestore.collection("battle_rooms");

  Stream<BattleRoomModel?> listenBattleRoom(String roomId) {
    return FirebaseFirestore.instance
        .collection('battle_rooms')
        .doc(roomId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return BattleRoomModel.fromMap(doc.data()!);
        });
  }

}
