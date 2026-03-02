import 'dart:convert';

import 'package:flaguiz/models/adventure_model.dart';
import 'package:flutter/services.dart';

class AdventureRepository {
  AdventureRepository();

  Future<dynamic> loadDataList() async{
    final String response = await rootBundle.loadString('assets/json/adventure.json');
    final data = await json.decode(response);
    List list = data as List;
    List<AdventureModel> levelList = list.map((e) => AdventureModel.fromJson(e)).toList();
    return levelList;
  }

}