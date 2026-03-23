import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/adventure_completed_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/repositories/user_repository.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    _repo = UserRepository();
  }

  late UserRepository _repo;
  UserModel? _user;
  CountryModel? _country;

  UserModel? get user => _user;
  CountryModel? get country => _country;

  bool get isLoaded => _user != null;

  //// Local Data

  Future<void> createOrGetUser() async {
    _user = await _repo.createOrGetUser();
    notifyListeners();
  }

  Future<void> updateAllUserData(UserModel newUser) async {
    _user = newUser;
    await _repo.updateUser(newUser);
    notifyListeners();
  }

  Future<void> addUserCoin(int coin) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    updateUser.coin = (updateUser.coin ?? 0) + coin;
    await _repo.updateUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> reduceUserCoin(int coin) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    updateUser.coin = (updateUser.coin ?? 0) - coin;
    await _repo.updateUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> updateUserDataForUsername(String username) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;

    if (username != '') {
      updateUser.username = username;
    }

    await _repo.updateUser(updateUser);
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

    await _repo.updateUser(updateUser);
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

    await _repo.updateUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> updateUserDataForAchievement(String id, int coin) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;

    updateUser.achievements?.add(id);
    updateUser.coin = (updateUser.coin ?? 0) + coin; // Add Coin
    await _repo.updateUser(updateUser);
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
      await _repo.updateUser(updateUser);
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

    await _repo.updateUser(updateUser);
    _user = updateUser;
    notifyListeners();
  }

  Future<void> updateUserDataForCountry(
      String countryId, List<CountryModel> list) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (countryId != '') updateUser.country = countryId;

    await _repo.updateUser(updateUser);
    _user = updateUser;
    await countryById(countryId, list);
    notifyListeners();
  }

  Future<void> updatedUserAvatar(List<String> list) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (list != []) {
      updateUser.avatars = list;
      await _repo.updateUser(updateUser);
      _user = updateUser;
      notifyListeners();
    }
  }

  Future<void> updatedUserBorder(List<String> list) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (list != []) {
      updateUser.borders = list;
      await _repo.updateUser(updateUser);
      _user = updateUser;
      notifyListeners();
    }
  }

  Future<void> updatedUserBackground(List<String> list) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (list != []) {
      updateUser.backgrounds = list;
      await _repo.updateUser(updateUser);
      _user = updateUser;
      notifyListeners();
    }
  }

  Future<void> updatedUserBanner(List<String> list) async {
    UserModel updateUser = _user ?? CcConfig.DEFAULT_USER;
    if (list != []) {
      updateUser.banners = list;
      await _repo.updateUser(updateUser);
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

  Future<void> logout() async {
    await _repo.deleteUser();
    _user = null;
    notifyListeners();
  }

  @override
  void dispose() {
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    super.dispose();
  }
}
