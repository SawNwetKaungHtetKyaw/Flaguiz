import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? country;
  @HiveField(4)
  List<String>? avatars;
  @HiveField(5)
  List<String>? borders;
  @HiveField(6)
  List<String>? backgrounds;
  @HiveField(7)
  List<String>? banners;
  @HiveField(8)
  List<String>? achievements;
  @HiveField(9)
  int? trophy;
  @HiveField(10)
  int? coin;
  @HiveField(11)
  int? energy;
  @HiveField(12)
  List<AdventureCompletedModel>? adventureCompletedList;
  @HiveField(13)
  List<ChallengeCompletedModel>? challengeCompletedList;
  @HiveField(14)
  List<String>? friendIds;
  @HiveField(15)
  bool? hasPremium;
  @HiveField(16)
  DateTime? updatedAt;
  @HiveField(17)
  DateTime? syncedAt;

  UserModel(
      {this.id,
      this.username,
      this.email,
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
      this.challengeCompletedList,
      this.friendIds,
      this.hasPremium,
      this.updatedAt,
      this.syncedAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;

      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);

      return null;
    }

    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
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
      friendIds: List<String>.from(json['friend_ids'] ?? []),
      hasPremium: json['has_premium'],
      updatedAt: parseDate(json['updated_at']),
      syncedAt: parseDate(json['synced_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
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
          ChallengeCompletedModel().toJsonList(challengeCompletedList),
      "friend_ids": friendIds,
      "has_premium": hasPremium,
      "updated_at": updatedAt,
      "synced_at" : syncedAt
    };
  }
}
