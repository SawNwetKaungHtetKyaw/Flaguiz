// providers/battle_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

import '../models/battle_room_model.dart';
import '../repositories/battle_repository.dart';

class BattleProvider extends ChangeNotifier {
  BattleProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    _repo = initRepo(buildContext);
  }

  static BattleRepository initRepo(BuildContext context) {
    return BattleRepository();
  }

  late BattleRepository _repo;

  BattleRoomModel? room;

  void listenRoom(String roomId) {
    _repo.roomStream(roomId).listen((event) {
      if (!event.exists) return;

      room = BattleRoomModel.fromMap(event.data() as Map<String, dynamic>);
      notifyListeners();
    });
  }

  Stream<DocumentSnapshot> roomStream(String roomId) {
    return _repo.roomStream(roomId);
  }

  Future<String> createChallenge({
    required List<int> questions,
    required MiniProfileModel host,
    required MiniProfileModel friend,
  }) async {
    return _repo.createChallenge(
      questions: questions,
      host: host,
      friend: friend,
    );
  }

  Future<bool> acceptBattle(String roomId) async {
    return _repo.acceptBattle(roomId);
  }

  Future<void> declineBattle(String roomId) async {
    _repo.declineBattle(roomId);
  }

  Future<void> timeoutBattle(String roomId) async {
    _repo.timeoutBattle(roomId);
  }

  Stream<QuerySnapshot> incomingChallenge(String myId) {
    return _repo.incomingChallenge(myId);
  }

  Future<void> deleteBattleRoom(String roomId) async {
    _repo.deleteBattleRoom(roomId);
  }

  @override
  void dispose() {
    Utils.printLog(
      '${runtimeType.toString()} Dispose $hashCode',
      important: true,
    );
    super.dispose();
  }
}
