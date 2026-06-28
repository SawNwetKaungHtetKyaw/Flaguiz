
import 'package:hive/hive.dart';

part 'premium_model.g.dart';

@HiveType(typeId: 5)
class PremiumModel {
  @HiveField(0)
  final bool isPremium;

  @HiveField(1)
  final DateTime? expireDate;

  @HiveField(2)
  final String? purchaseToken;

  PremiumModel({required this.isPremium, this.expireDate, this.purchaseToken});

  factory PremiumModel.fromJson(Map<String, dynamic> json) {
    return PremiumModel(
      isPremium: json['is_premium'] ?? false,
      expireDate:
          json['expireDate'] != null
              ? DateTime.parse(json['expire_date'])
              : null,
      purchaseToken: json['purchase_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_premium': isPremium,
      'expire_date': expireDate?.toIso8601String(),
      'purchase_token': purchaseToken,
    };
  }
}
