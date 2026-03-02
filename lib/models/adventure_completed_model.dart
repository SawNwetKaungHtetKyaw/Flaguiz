import 'package:hive/hive.dart';

part 'adventure_completed_model.g.dart';

@HiveType(typeId: 2)
class AdventureCompletedModel {
  @HiveField(0)
  String? levelId;
  @HiveField(1)
  String? life;

  AdventureCompletedModel({
    this.levelId,
    this.life,
  });

  factory AdventureCompletedModel.fromJson(Map<String, dynamic> json) {
    return AdventureCompletedModel(
        levelId: json["level_id"], life: json["life"]);
  }

  List<AdventureCompletedModel> fromJsonList(List<dynamic> dynamicDataList) {
    final List<AdventureCompletedModel> dynamicList =
        <AdventureCompletedModel>[];
    for (dynamic json in dynamicDataList) {
      if (json != null) {
        dynamicList.add(AdventureCompletedModel.fromJson(json));
      }
    }
    return dynamicList;
  }

  Map<String, dynamic> toJson(dynamic object) {
    final data = <String, dynamic>{};
    data['level_id'] = object.levelId;
    data['life'] = object.life;
    return data;
  }

  List<Map<String, dynamic>?> toJsonList(List<AdventureCompletedModel>? list) {
    final List<Map<String, dynamic>?> dynamicList = <Map<String, dynamic>?>[];
    if (list != null) {
      for (dynamic data in list) {
        if (data != null) {
          dynamicList.add(toJson(data));
        }
      }
    }
    return dynamicList;
  }
}
