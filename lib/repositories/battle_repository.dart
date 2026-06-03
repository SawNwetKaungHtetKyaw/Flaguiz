// repositories/battle_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaguiz/models/battle_room_model.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/service/battle_firestore_service.dart';

class BattleRepository {
  final BattleFirestoreService firestore = BattleFirestoreService();

  Stream<BattleRoomModel?> listenBattleRoom(String roomId) {
    return firestore.listenBattleRoom(roomId);
  }

  Future<String> createChallenge({
    required MiniProfileModel host,
    required MiniProfileModel friend,
    required List<int> questions,
  }) async {
    final roomRef = firestore.battleRooms.doc();

    await roomRef.set({
      'room_id': roomRef.id,
      'status': 'pending',
      'host': host.toMap(),
      'friend': friend.toMap(),
      'questions': questions,
      'host_progress': {for (int i = 0; i < 20; i++) '$i': 0},

      'friend_progress': {for (int i = 0; i < 20; i++) '$i': 0},
      'created_at': FieldValue.serverTimestamp(),
    });

    return roomRef.id;
  }

  Future<bool> isRoomExist(String roomId) async {
    final roomRef = await firestore.battleRooms.doc(roomId).get();

    return roomRef.exists;
  }

  Future<bool> acceptBattle(String roomId) async {
    if (await isRoomExist(roomId)) {
      await firestore.battleRooms.doc(roomId).update({'status': 'playing'});
      return true;
    } else {
      return false;
    }
  }

  Future<void> declineBattle(String roomId) async {
    if (!await isRoomExist(roomId)) return;
    await firestore.battleRooms.doc(roomId).update({'status': 'declined'});
  }

  Future<void> timeoutBattle(String roomId) async {
    if (!await isRoomExist(roomId)) return;
    await firestore.battleRooms.doc(roomId).update({'status': 'timeout'});
  }

  Stream<DocumentSnapshot> roomStream(String roomId) {
    return firestore.battleRooms.doc(roomId).snapshots();
  }

  Stream<QuerySnapshot> incomingChallenge(String myId) {
    return firestore.battleRooms
        .where("status", isEqualTo: "pending")
        .where("friend.id", isEqualTo: myId)
        .snapshots();
  }

  Future<void> deleteBattleRoom(String roomId) async {
    try {
      await firestore.battleRooms.doc(roomId).delete();
    } catch (_) {}
  }
}
