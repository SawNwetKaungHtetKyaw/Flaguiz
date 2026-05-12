import 'dart:math';

import 'package:flaguiz/bot/bot_data.dart';
import 'package:flaguiz/bot/bot_model.dart';
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

  Future<BotModel> createBot() async {
    CountryModel? country =
        await _repo.getById(_random.nextInt(234).toString());

    return BotModel(
        username: _randomItem(BotData.username),
        avatar: _randomItem(BotData.avatars),
        border: _randomItem(BotData.borders),
        banner: _randomItem(BotData.banners),
        trophy: 0,
        country: country);
  }

  Future<BotModel> createUserBot(UserModel? user) async {
    ShopModel? avatar =
        AvatarRepository().getById(user?.avatars?[0] ?? 'AVT_001');
    ShopModel? border =
        BorderRepository().getById(user?.borders?[0] ?? 'BD_001');
    ShopModel? banner =
        BannerRepository().getById(user?.banners?[0] ?? 'BN_001');

    CountryModel? country = await _repo.getById(user?.country ?? '0');
    return BotModel(
        username: user?.username ?? 'Player',
        avatar: avatar?.imageUrl ?? _randomItem(BotData.avatars),
        border: border?.imageUrl ?? _randomItem(BotData.borders),
        banner: banner?.imageUrl ?? _randomItem(BotData.banners),
        trophy: user?.trophy ?? 0,
        country: country);
  }

  static String _randomItem(List<String> list) {
    return list[_random.nextInt(list.length)];
  }
}
