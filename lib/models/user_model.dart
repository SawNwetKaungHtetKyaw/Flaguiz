import 'package:flaguiz/models/adventure_completed_model.dart';
import 'package:flaguiz/models/challenge_completed_model.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? username;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? password;
  @HiveField(4)
  String? country;
  @HiveField(5)
  List<String>? avatars;
  @HiveField(6)
  List<String>? borders;
  @HiveField(7)
  List<String>? backgrounds;
  @HiveField(8)
  List<String>? banners;
  @HiveField(9)
  List<String>? achievements;
  @HiveField(10)
  int? trophy;
  @HiveField(11)
  int? coin;
  @HiveField(12)
  int? energy;
  @HiveField(13)
  List<AdventureCompletedModel>? adventureCompletedList;
  @HiveField(14)
  List<ChallengeCompletedModel>? challengeCompletedList;

  UserModel(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.country,
      this.avatars,
      this.borders,
      this.backgrounds,
      this.banners,
      this.achievements,
      this.trophy,
      this.coin,
      this.energy,
      this.adventureCompletedList,
      this.challengeCompletedList});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      country: json['country'],
      avatars: List<String>.from(json['avatars'] ?? []),
      borders: List<String>.from(json['borders'] ?? []),
      backgrounds: List<String>.from(json['backgrounds'] ?? []),
      banners: List<String>.from(json['banners'] ?? []),
      achievements: List<String>.from(json['achievements'] ?? []),
      trophy: json['trophy'],
      coin: json['coin'],
      energy: json['energy'],
      adventureCompletedList: json['adventure_completed'] != null
          ? AdventureCompletedModel().fromJsonList(json['adventure_completed'])
          : [],
      challengeCompletedList: json['challenge_completed'] != null
          ? ChallengeCompletedModel().fromJsonList(json['challenge_completed'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "password": password,
      "country": country,
      "avatars": avatars,
      "borders": borders,
      "backgrounds": backgrounds,
      "banners": banners,
      "achievements": achievements,
      "trophy": trophy,
      "coin": coin,
      "energy": energy,
      "adventure_completed":
          AdventureCompletedModel().toJsonList(adventureCompletedList),
      "challenge_completed":
          ChallengeCompletedModel().toJsonList(challengeCompletedList)
    };
  }
}
