import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/databases/user_dao.dart';
import 'package:flaguiz/service/firestore_service.dart';
import 'package:flaguiz/utils/utils.dart';

import '../models/user_model.dart';

class UserRepository {
  final UserDao _dao = UserDao();
  final FirestoreService _firestoreService = FirestoreService();

  // Get local user
  Future<UserModel?> getLocalUser() => _dao.getUser();

  // Create default anonymous user locally
  Future<UserModel> createAnonymousUser() async {
    final UserModel user = CcConfig.DEFAULT_USER;
    if (await Utils.hasInternet()) {
      user.playerID = await Utils.generateUniqueId();
    } else {
      user.playerID = "#${Utils.generateId()}";
    }

    await _dao.saveLocalUser(user);
    return user;
  }

  // Sync Hive user to Firestore after Google login
  Future<void> syncUserToFirestore(UserModel user) async {
    if (user.id == null) return;

    await _firestoreService.createOrUpdateUser(user);

    await _dao.saveLocalUser(user);
  }

  Future<UserModel> handleGoogleLogin(UserModel localUser, String uid) async {
    // Check Firestore user
    final firestoreUser = await _firestoreService.getUser(uid);

    if (firestoreUser != null) {
      await _dao.saveLocalUser(firestoreUser);
      return firestoreUser;
    } else {
      localUser.id = uid;

      await _firestoreService.createOrUpdateUser(localUser);
      await _dao.saveLocalUser(localUser);

      return localUser;
    }
  }

  Future<void> deleteUserFromFirestore(String uid) async {
    // Delete Firestore
    await _firestoreService.deleteUser(uid);
  }

  // Delete local user (for logout/reset)
  Future<void> resetUser() async {
    await _dao.deleteUser();
  }

  Future<UserModel?> getFirestoreUser(String uid) async {
    return await _firestoreService.getUser(uid);
  }

  Future<void> createFirestoreUser(UserModel user) async {
    await _firestoreService.createOrUpdateUser(user);
  }

  Future<void> saveLocalUser(UserModel user) => _dao.saveLocalUser(user);
}
