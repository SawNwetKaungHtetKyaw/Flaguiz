import 'package:hive/hive.dart';
part 'shop_model.g.dart';

@HiveType(typeId: 4)
class ShopModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? subName;

  @HiveField(3)
  String? imageUrl;

  @HiveField(4)
  int? price;

  ShopModel({this.id, this.name, this.subName, this.imageUrl, this.price});

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
        id: json["id"],
        name: json["name"],
        subName: json["sub_name"],
        imageUrl: json["image_url"],
        price: json["price"]);
  }

  List<ShopModel> fromJsonList(List<dynamic> dynamicDataList) {
    final List<ShopModel> dynamicList = <ShopModel>[];
    for (dynamic json in dynamicDataList) {
      if (json != null) {
        dynamicList.add(ShopModel.fromJson(json));
      }
    }
    return dynamicList;
  }

  Map<String, dynamic> toJson(dynamic object) {
    final data = <String, dynamic>{};
    data['id'] = object.id;
    data['name'] = object.name;
    data['sub_name'] = object.subName;
    data['image_url'] = object.imageUrl;
    data['price'] = object.price;
    return data;
  }

  List<Map<String, dynamic>?> toJsonList(List<ShopModel>? list) {
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
