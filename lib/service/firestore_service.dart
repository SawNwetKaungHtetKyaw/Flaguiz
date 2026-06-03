import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaguiz/models/country_leaderboard_model.dart';
import 'package:flaguiz/models/friend_request_model.dart';
import 'package:flaguiz/utils/enum/friend_status.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'users';

  Future<void> createOrUpdateUser(UserModel user) async {
    if (user.id == null) return;
    Utils.printLog('✅===> Create or Update User To Firebase ${user.id}');
    final data = user.toJson();

    data.remove('friend_ids');
    await _firestore
        .collection(collection)
        .doc(user.id)
        .set(data, SetOptions(merge: true));
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
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .where('player_id', isEqualTo: playerID)
            .limit(1)
            .get();

    return doc.docs.isNotEmpty;
  }

  ///=====================================
  /// Leaderboard Section
  ///=====================================

  /// Local Leaderboard Section
  Future<List<UserModel>> getLocalLeaderBoard(String countryId) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .where("country", isEqualTo: countryId)
              .where("trophy", isGreaterThan: 0)
              .orderBy("trophy", descending: true)
              .orderBy("updated_at")
              .limit(50)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        data["id"] = doc.id;

        return UserModel.fromJson(data);
      }).toList();
    } catch (e) {
      print("ERROR GET TOP USERS => $e");
      return [];
    }
  }

  /// Global Leaderboard Section
  Future<List<UserModel>> getGlobalLeaderBoard() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .where("trophy", isGreaterThan: 0)
              .orderBy("trophy", descending: true)
              .orderBy("updated_at")
              .limit(100)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        data["id"] = doc.id;

        return UserModel.fromJson(data);
      }).toList();
    } catch (e) {
      print("ERROR GET TOP USERS => $e");
      return [];
    }
  }

  Future<List<CountryLeaderboardModel>> getCountryLeaderboard() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .where("trophy", isGreaterThan: 0)
              .where("country", isNotEqualTo: '0')
              .get();

      Map<String, int> countryMap = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();

        final country = data["country"] ?? "0";
        final trophy = (data["trophy"] ?? 0) as int;

        countryMap[country] = (countryMap[country] ?? 0) + trophy;
      }

      List<CountryLeaderboardModel> result =
          countryMap.entries.map((e) {
            return CountryLeaderboardModel(
              country: e.key,
              totalTrophy: e.value,
            );
          }).toList();

      result.sort((a, b) => b.totalTrophy.compareTo(a.totalTrophy));

      return result;
    } catch (e) {
      print("ERROR COUNTRY LEADERBOARD => $e");
      return [];
    }
  }

  ///=====================================
  /// Friend Section
  ///=====================================

  /// Search Friend
  Future<UserModel?> searchUserByPlayerId(String playerID) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .where('player_id', isEqualTo: playerID)
            .limit(1)
            .get();

    if (doc.docs.isEmpty) return null;
    return UserModel.fromJson(doc.docs.first.data());
  }

  /// Send Friend Request
  Future<void> sendRequest(UserModel user, UserModel friend) async {
    final existing =
        await _firestore
            .collection('friend_requests')
            .where('from', isEqualTo: user.id)
            .where('to', isEqualTo: friend.id)
            .where('status', isEqualTo: 'pending')
            .get();

    if (existing.docs.isNotEmpty) return;

    await _firestore.collection('friend_requests').add({
      'from': user.id,
      'to': friend.id,
      'user': user.toJson(),
      'friend': friend.toJson(),
      'status': 'pending',
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  /// Cancel Request
  Future<void> cancelRequest(String from, String to) async {
    final query =
        await _firestore
            .collection('friend_requests')
            .where('from', isEqualTo: from)
            .where('to', isEqualTo: to)
            .where('status', isEqualTo: 'pending')
            .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }

  /// Get Friend status
  Stream<FriendStatus> getFriendStatus(String myId, String otherId) {
    final userDocStream =
        FirebaseFirestore.instance.collection('users').doc(myId).snapshots();

    final requestStream =
        FirebaseFirestore.instance
            .collection('friend_requests')
            .where('status', isEqualTo: 'pending')
            .snapshots();

    return Rx.combineLatest2(userDocStream, requestStream, (
      userDoc,
      requestSnapshot,
    ) {
      final friends = List<String>.from(userDoc['friend_ids'] ?? []);

      if (friends.contains(otherId)) {
        return FriendStatus.friend;
      }

      for (var doc in requestSnapshot.docs) {
        final data = doc.data();

        if (data['from'] == myId && data['to'] == otherId) {
          return FriendStatus.pending;
        }

        if (data['from'] == otherId && data['to'] == myId) {
          return FriendStatus.received;
        }
      }

      return FriendStatus.none;
    });
  }

  /// Listen Friend Get Request
  Stream<List<FriendRequestModel>> listenGetRequests(String userId) {
    return _firestore
        .collection('friend_requests')
        .where('to', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((e) => FriendRequestModel.fromDoc(e)).toList(),
        );
  }

  /// Listen Friend Send Request
  Stream<List<FriendRequestModel>> listenSendRequests(String userId) {
    return _firestore
        .collection('friend_requests')
        .where('from', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((e) => FriendRequestModel.fromDoc(e)).toList(),
        );
  }

  Future<void> unfriend({
    required String userId,
    required String playerId,
  }) async {
    await _firestore.runTransaction((tx) async {
      final userARef = _firestore.collection('users').doc(userId);
      final userBRef = _firestore.collection('users').doc(playerId);

      // remove each other
      tx.update(userARef, {
        'friend_ids': FieldValue.arrayRemove([playerId]),
      });

      tx.update(userBRef, {
        'friend_ids': FieldValue.arrayRemove([userId]),
      });
    });
  }

  Stream<bool> isFriendStream(String userId, String playerId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
          final List friends = doc.data()?['friend_ids'] ?? [];
          return friends.contains(playerId);
        });
  }

  Future<void> acceptRequest(String requestId, String from, String to) async {
    await _firestore.runTransaction((tx) async {
      final reqRef = _firestore.collection('friend_requests').doc(requestId);
      final userA = _firestore.collection('users').doc(from);
      final userB = _firestore.collection('users').doc(to);

      tx.update(reqRef, {'status': 'accepted'});

      tx.update(userA, {
        'friend_ids': FieldValue.arrayUnion([to]),
      });

      tx.update(userB, {
        'friend_ids': FieldValue.arrayUnion([from]),
      });
    });
    await _firestore.collection('friend_requests').doc(requestId).delete();
  }

  Future<void> declineRequest(String requestId) async {
    await _firestore.collection('friend_requests').doc(requestId).delete();
  }

  Stream<List<UserModel>> listenFriends(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .asyncMap((doc) async {
          final ids = List<String>.from(doc.data()?['friend_ids'] ?? []);

          if (ids.isEmpty) return [];

          final query =
              await FirebaseFirestore.instance
                  .collection('users')
                  .where(FieldPath.documentId
                  , whereIn: ids.take(50).toList()
                  )
                  .get();

          return query.docs.map((e) => UserModel.fromJson(e.data())).toList();
        });
  }
}
