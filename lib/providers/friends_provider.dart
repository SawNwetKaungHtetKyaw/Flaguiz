import 'dart:async';

import 'package:flaguiz/models/friend_request_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/repositories/friends_repository.dart';
import 'package:flaguiz/service/auth_service.dart';
import 'package:flaguiz/utils/enum/friend_status.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class FriendsProvider extends ChangeNotifier {
  FriendsProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    final uid = _auth.currentUser?.uid;
    _repo = FriendsRepository();
    if (uid != null) {
      listenRequests(uid);
    }
  }
  final AuthService _auth = AuthService();
  late FriendsRepository _repo;
  Future<UserModel?>? searchFuturePlayer;
  List<FriendRequestModel> requests = [];
  bool isLoading = false;

  StreamSubscription? _sub;

  Future<void> searchUserByPlayerId(String userId, String playerID) async {
    searchFuturePlayer = _repo.searchUserByPlayerId(playerID);
    notifyListeners();
  }

  Future<UserModel?> getFriendById(String playerID) async {
    return _repo.searchUserByPlayerId(playerID);
  }

  void listenRequests(String userId) {
    _sub?.cancel();

    _sub = _repo.listenRequest(userId).listen((data) {
      requests = data;
      notifyListeners();
    });
  }

  Future<void> sendRequest(UserModel user, String to) async {
    await _repo.sendRequest(user, to);
  }

  Future<void> cancelRequest(String from, String to) async {
    await _repo.cancelRequest(from, to);
  }

  Future<void> unfriend({
    required String userId,
    required String playerId,
  }) async {
    await _repo.unfriend(userId: userId, playerId: playerId);
  }

  Stream<bool> isFriendStream(String currentUserId, String targetUserId) {
    return _repo.isFriendStream(currentUserId, targetUserId);
  }

  Stream<FriendStatus> getFriendStatus(String myId, String otherId) {
    return _repo.getFriendStatus(myId, otherId);
  }

  Future<void> acceptRequest(FriendRequestModel req, String currentUser) async {
    await _repo.accept(req.id, req.from, currentUser);
  }

  Future<void> declineRequest(String requestId) async {
    await _repo.decline(requestId);
  }

  Stream<List<UserModel>> listenFriends(String userId) {
    return _repo.listenFriends(userId);
  }

  @override
  void dispose() {
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    _sub?.cancel();
    super.dispose();
  }
}
