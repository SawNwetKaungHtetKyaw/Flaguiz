import 'package:hive/hive.dart';

part 'country_model.g.dart';

@HiveType(typeId: 3)
class CountryModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? flagUrl;
  @HiveField(3)
  String? mapUrl;
  @HiveField(4)
  String? currency;
  @HiveField(5)
  String? region;
  @HiveField(6)
  String? capital;
  @HiveField(7)
  String? description;
  @HiveField(8)
  List<String>? popularPlaces;
  @HiveField(9)
  List<String>? similarFlags;
  @HiveField(10)
  String? createdAt;
  @HiveField(11)
  String? updatedAt;

  CountryModel({
    this.id,
    this.name,
    this.flagUrl,
    this.mapUrl,
    this.currency,
    this.region,
    this.capital,
    this.description,
    this.popularPlaces,
    this.similarFlags,
    this.createdAt,
    this.updatedAt,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      flagUrl: json['flag_url'] as String?,
      mapUrl: json['map_url'] as String?,
      currency: json['currency'] as String?,
      region: json['region'] as String?,
      capital: json['capital'] as String?,
      description: json['description'] as String?,
      popularPlaces:
          (json['popular_places'] as List?)?.map((e) => e.toString()).toList(),
      similarFlags:
          (json['similar_flags'] as List?)?.map((e) => e.toString()).toList(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'flag_url': flagUrl,
      'map_url': mapUrl,
      'currency': currency,
      'region': region,
      'capital': capital,
      'description': description,
      'popular_places': popularPlaces,
      'similar_flags': similarFlags,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
