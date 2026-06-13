import 'dart:math';

import 'package:flaguiz/bot/bot_data.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/repositories/avatar_repository.dart';
import 'package:flaguiz/repositories/banner_repository.dart';
import 'package:flaguiz/repositories/border_repository.dart';
import 'package:flaguiz/repositories/country_repository.dart';

class BotFactory {
  static final Random _random = Random();
  final CountryRepository _repo = CountryRepository();
  final AvatarRepository _avatarRepository = AvatarRepository();
  final BorderRepository _borderRepository = BorderRepository();
  final BannerRepository _bannerRepository = BannerRepository();

  Future<MiniProfileModel> createBot() async {
    CountryModel? country = await _repo.getById(
      _random.nextInt(234).toString(),
    );

    List<ShopModel>? avatars = _avatarRepository.getAll();
    List<ShopModel>? borders = _borderRepository.getAll();
    List<ShopModel>? banners = _bannerRepository.getAll();

    return MiniProfileModel(
      username: _randomItem(BotData.username),
      avatar: _randomItem(idList(avatars, BotData.avatars)),
      border: _randomItem(idList(borders, BotData.borders)),
      banner: _randomItem(idList(banners, BotData.banners)),
      trophy: 0,
      country: country,
    );
  }

  List<String> idList(List<ShopModel>? list, List<String> defaultList) {
    if (list != null && list.isNotEmpty && list != []) {
      List<String> ids = list.map((e) => e.id ?? '').toList();
      return ids;
    } else {
      return defaultList;
    }
  }

  Future<MiniProfileModel> createMiniProfile(UserModel? user) async {
    CountryModel? country = await _repo.getById(user?.country ?? '0');
    return MiniProfileModel(
      id: user?.id ?? '',
      username: user?.username ?? 'Player',
      avatar: user?.avatars?[0] ?? 'AVT_001',
      border: user?.borders?[0] ?? 'BD_001',
      banner: user?.banners?[0] ?? 'BN_001',
      trophy: user?.trophy ?? 0,
      country: country,
    );
  }

  static String _randomItem(List<String> list) {
    return list[_random.nextInt(list.length)];
  }
}
