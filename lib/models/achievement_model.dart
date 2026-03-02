class AchievementModel {
  String? id;
  String? name;
  String? imageUrl;
  String? message;

  AchievementModel(
      {this.id, this.name, this.message, this.imageUrl});

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
        id: json["id"],
        name: json["name"],
        imageUrl: json["image_url"],
        message: json["message"]);
  }

  List<AchievementModel> fromJsonList(List<dynamic> dynamicDataList) {
    final List<AchievementModel> dynamicList = <AchievementModel>[];
    for (dynamic json in dynamicDataList) {
      if (json != null) {
        dynamicList.add(AchievementModel.fromJson(json));
      }
    }
    return dynamicList;
  }

  Map<String, dynamic> toJson(dynamic object) {
    final data = <String, dynamic>{};
    data['id'] = object.id;
    data['name'] = object.name;
    data['image_url'] = object.imageUrl;
    data['message'] = object.message;
    return data;
  }

  List<Map<String, dynamic>?> toJsonList(List<AchievementModel>? list) {
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
