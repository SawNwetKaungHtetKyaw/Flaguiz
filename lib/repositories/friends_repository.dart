import 'package:flaguiz/models/friend_request_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/service/firestore_service.dart';
import 'package:flaguiz/utils/enum/friend_status.dart';

class FriendsRepository {
  FriendsRepository();

  final FirestoreService _firestore = FirestoreService();

  Future<UserModel?> searchUserByPlayerId(String playerID) async {
    return await _firestore.searchUserByPlayerId(playerID);
  }

  Future<void> sendRequest(UserModel user, String to) async {
    await _firestore.sendRequest(user, to);
  }

  Future<void> cancelRequest(String from, String to) async {
    await _firestore.cancelRequest(from, to);
  }

  Stream<FriendStatus> getFriendStatus(String myId, String otherId) {
    return _firestore.getFriendStatus(myId, otherId);
  }

  Stream<List<FriendRequestModel>> listenRequest(String userId) {
    return _firestore.listenRequests(userId);
  }

  Future<void> unfriend({
    required String userId,
    required String playerId,
  }) async {
    await _firestore.unfriend(userId: userId, playerId: playerId);
  }

  Stream<bool> isFriendStream(String currentUserId, String targetUserId) {
    return _firestore.isFriendStream(currentUserId, targetUserId);
  }

  Future<void> accept(String requestId, String from, String to) async {
    await _firestore.acceptRequest(requestId, from, to);
  }

  Future<void> decline(String requestId) async {
     await _firestore.declineRequest(requestId);
  }

  Stream<List<UserModel>> listenFriends(String userId) {
    return _firestore.listenFriends(userId);
  }
}
