import 'dart:async';

import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/adventure_completed_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/repositories/user_repository.dart';
import 'package:flaguiz/service/auth_service.dart';
import 'package:flaguiz/utils/enum/login_status.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    _repo = UserRepository();
    startPeriodicSync();
  }

  final AuthService _auth = AuthService();
  Timer? _syncTimer;

  late UserRepository _repo;
  UserModel? _user;
  CountryModel? _country;

  bool get isLoggedIn => _auth.currentUser != null;
  UserModel? get user => _user;
  CountryModel? get country => _country;

  // =========================================
  // Auth , Create & Login With Google Section
  // =========================================

  Future<void> initUser() async {
    _user = await _repo.getLocalUser();
    _user ??= await _repo.createAnonymousUser();
    notifyListeners();
  }

  Future<LoginStatus> loginWithGoogle(BuildContext context) async {
    try {
      final firebaseUser = await _auth.signInWithGoogle();
      if (firebaseUser == null) {
        return LoginStatus.cancelled;
      }

      _user ??= await _repo.getLocalUser();

      final firestoreUser = await _repo.getFirestoreUser(firebaseUser.uid);

      if (firestoreUser != null) {
        return LoginStatus.existingUser;
      } else {
        _user!.id = firebaseUser.uid;
        _user!.email = firebaseUser.email;

        await _repo.createFirestoreUser(_user!);
        await _repo.saveLocalUser(_user!);

        if (context.mounted) {
          Utils.showToastMessage(context, 'Welcome to Flaguiz!',
              backgroundColor: successColor);
        }
        notifyListeners();
        return LoginStatus.newUser;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadExistingUser(BuildContext context) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final firestoreUser = await _repo.getFirestoreUser(uid);
    if (firestoreUser != null) {
      _user = firestoreUser;
      await _repo.saveLocalUser(_user!);

      if (!context.mounted) return;
      Utils.showToastMessage(context, 'Welcome back!\n"${_user?.username}"',
          backgroundColor: successColor);
    }
    notifyListeners();
  }

  // =========================================
  // User Data Update Or Sync Section
  // =========================================

  void startPeriodicSync() {
    _syncTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      await syncLocalToFirestoreIfNeeded();
    });
  }

  Future<void> syncLocalToFirestoreIfNeeded() async {
    if (!await Utils.hasInternet()) return;

    if (!isLoggedIn || _user == null) return;

    if (_user!.updatedAt == _user!.syncedAt) return;

    try {
      await _repo.syncUserToFirestore(_user!);
      Utils.printLog("✅===> Synced local Hive user to Firestore");

      _user!.syncedAt = _user!.updatedAt;

      notifyListeners();
    } catch (e) {
      Utils.printLog("❌===> Failed to sync user: $e", important: false);
    }
  }

  // =========================================
  // User Delete Account & Logout Section
  // =========================================

  Future<void> deleteAccount() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // stop sync
    _syncTimer?.cancel();
    try {
      // Delete Firestore + Hive
      await _repo.deleteUserFromFirestore(uid);
      // Reset local user
      await _repo.resetUser();
      _user = null;
      _country = null;
      await initUser();
      // Delete Auth
      await _auth.deleteAccount();

      notifyListeners();
    } catch (e) {
      print("Delete account error: $e");
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    await _repo.resetUser();
    _user = null;
    _country = null;
    await initUser(); // recreate anonymous user
  }

  //// Local Data

  // Future<void> createOrGetUser() async {
  //   _user = await _repo.createOrGetUser();
  //   notifyListeners();
  // }

  Future<void> updateAllUserData(UserModel newUser) async {
    _user = newUser;
    await _repo.saveLocalUser(newUser);
    notifyListeners();
  }

  Future<void> addUserCoin(int coin) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    updateUser.coin = (updateUser.coin ?? 0) + coin;
    await _repo.saveLocalUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> reduceUserCoin(int coin) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    updateUser.coin = (updateUser.coin ?? 0) - coin;
    await _repo.saveLocalUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> updateUserDataForUsername(String username) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;

    if (username != '') {
      updateUser.username = username;
    }

    await _repo.saveLocalUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> updateUserDataForChallenge(
      String mode, int currentIndex, int coin) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;

    final int index = updateUser.challengeCompletedList
            ?.indexWhere((item) => item.mode == mode) ??
        -1;

    if (index != -1) {
      int currentComplete =
          int.parse(updateUser.challengeCompletedList?[index].complete ?? "0");
      if (currentComplete < currentIndex) {
        updateUser.challengeCompletedList?[index].complete =
            currentIndex.toString();
      }
    }

    updateUser.coin = (updateUser.coin ?? 0) + coin;

    await _repo.saveLocalUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> updateUserDataForAdventure(
      String currentLevelId, int life, int coin) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;

    /// Update current level
    final int index = updateUser.adventureCompletedList
            ?.indexWhere((item) => item.levelId == currentLevelId) ??
        -1;
    if (index != -1) {
      int currentLife =
          int.parse(updateUser.adventureCompletedList?[index].life ?? "0");
      if (currentLife < life) {
        updateUser.adventureCompletedList?[index].life = life.toString();
      }
    }

    updateUser.coin = (updateUser.coin ?? 0) + coin; // Add Coin

    await _repo.saveLocalUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> updateUserDataForAchievement(String id, int coin) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;

    updateUser.achievements?.add(id);
    updateUser.coin = (updateUser.coin ?? 0) + coin; // Add Coin
    await _repo.saveLocalUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> updateUserDataForNextAdventureLevel(String nextLevelId) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (nextLevelId != '') {
      /// Add new adventure level
      final bool exists = updateUser.adventureCompletedList
              ?.any((item) => item.levelId == nextLevelId) ??
          false;
      if (!exists) {
        updateUser.adventureCompletedList
            ?.add(AdventureCompletedModel(levelId: nextLevelId, life: "0"));
      }
      await _repo.saveLocalUser(updateUser);
      _user = updateUser;
      notifyListeners();
    }
  }

  Future<void> updateUserDataForBuyItem(String itemId) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (itemId.startsWith('AVT')) updateUser.avatars?.add(itemId);
    if (itemId.startsWith('BD')) updateUser.borders?.add(itemId);
    if (itemId.startsWith('BG')) updateUser.backgrounds?.add(itemId);
    if (itemId.startsWith('BN')) updateUser.banners?.add(itemId);

    await _repo.saveLocalUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> updateUserDataForCountry(
      String countryId, List<CountryModel> list) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (countryId != '') updateUser.country = countryId;

    await _repo.saveLocalUser(updateUser);
    _user = updateUser;
    await countryById(countryId, list);
    notifyListeners();
  }

  Future<void> updatedUserAvatar(List<String> list) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (list != []) {
      updateUser.avatars = list;
      await _repo.saveLocalUser(updateUser);
      _user = updateUser;
      notifyListeners();
    }
  }

  Future<void> updatedUserBorder(List<String> list) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (list != []) {
      updateUser.borders = list;
      await _repo.saveLocalUser(updateUser);
      _user = updateUser;
      notifyListeners();
    }
  }

  Future<void> updatedUserBackground(List<String> list) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (list != []) {
      updateUser.backgrounds = list;
      await _repo.saveLocalUser(updateUser);
      _user = updateUser;
      notifyListeners();
    }
  }

  Future<void> updatedUserBanner(List<String> list) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (list != []) {
      updateUser.banners = list;
      await _repo.saveLocalUser(updateUser);
      _user = updateUser;
      notifyListeners();
    }
  }

  Future<void> countryById(String countryId, List<CountryModel> list) async {
    if (countryId != '' && list != []) {
      final int index = list.indexWhere((country) => country.id == countryId);
      _country = list[index];
    }
  }

  // Future<void> logout() async {
  //   await _repo.deleteUser();
  //   _user = null;
  //   notifyListeners();
  // }

  @override
  void dispose() {
    _syncTimer?.cancel();
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    super.dispose();
  }
}
