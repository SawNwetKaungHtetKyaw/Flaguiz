import 'package:flaguiz/models/country_model.dart';

class BotModel {
  String? username;
  CountryModel? country;
  String? avatar;
  String? border;
  String? banner;
  int? trophy;
  String? difficulty;

  BotModel({
    this.username,
    this.country,
    this.avatar,
    this.border,
    this.banner,
    this.trophy,
    this.difficulty
  });
}