import 'dart:convert';

import 'package:flaguiz/models/achievement_model.dart';
import 'package:flutter/services.dart';

class AchievementRepository {
  AchievementRepository();

  Future<dynamic> loadAchvDataList() async{
    final String response = await rootBundle.loadString('assets/json/achievement.json');
    final data = await json.decode(response);
    List list = data as List;
    List<AchievementModel> achvList = list.map((e) => AchievementModel.fromJson(e)).toList();
    return achvList;
  }

}