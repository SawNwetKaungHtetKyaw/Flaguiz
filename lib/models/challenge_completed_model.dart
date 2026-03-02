import 'package:hive/hive.dart';

part 'challenge_completed_model.g.dart';

@HiveType(typeId: 1)
class ChallengeCompletedModel {
  
  @HiveField(0)
  String? mode;
  @HiveField(1)
  String? complete;

  ChallengeCompletedModel({
    this.mode,
    this.complete,
  });

  factory ChallengeCompletedModel.fromJson(Map<String, dynamic> json) {
    return ChallengeCompletedModel(
        mode: json["mode"], complete: json["complete"]);
  }

  List<ChallengeCompletedModel> fromJsonList(List<dynamic> dynamicDataList) {
    final List<ChallengeCompletedModel> dynamicList =
        <ChallengeCompletedModel>[];
    for (dynamic json in dynamicDataList) {
      if (json != null) {
        dynamicList.add(ChallengeCompletedModel.fromJson(json));
      }
    }
    return dynamicList;
  }

  Map<String, dynamic> toJson(dynamic object) {
    final data = <String, dynamic>{};
    data['mode'] = object.mode;
    data['complete'] = object.complete;
    return data;
  }

  List<Map<String, dynamic>?> toJsonList(List<ChallengeCompletedModel>? list) {
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
