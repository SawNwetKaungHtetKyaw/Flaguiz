import 'package:flaguiz/models/country_model.dart';

class MiniProfileModel {
  String? id;
  String? username;
  CountryModel? country;
  String? avatar;
  String? border;
  String? banner;
  int? trophy;
  String? difficulty;

  MiniProfileModel({
    this.id,
    this.username,
    this.country,
    this.avatar,
    this.border,
    this.banner,
    this.trophy,
    this.difficulty
  });

  factory MiniProfileModel.fromMap(Map<String, dynamic> map) {
    return MiniProfileModel(
      id: map['id'],
      username: map['username'],
      country: CountryModel.fromJson(map['country'] ?? {}),
      avatar: map['avatar'],
      border: map['border'],
      banner: map['banner'],
      trophy: map['trophy'],
      difficulty: map['difficulty'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'username': username,
      'country': country?.toJson(),
      'avatar': avatar,
      'border': border,
      'banner': banner,
      'trophy': trophy,
      'difficulty': difficulty
    };
  }
}