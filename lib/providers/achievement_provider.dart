import 'package:flaguiz/models/achievement_model.dart';
import 'package:flaguiz/repositories/achievement_repository.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class AchievementProvider extends ChangeNotifier {

  AchievementProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    loadAchvList();
  }

  late AchievementRepository _repo;
  List<AchievementModel> _achvList = [];
  AchievementModel? _achv;

  List<AchievementModel> get achvList => _achvList;
  AchievementModel? get achc => _achv;

  set setAchvList(List<AchievementModel> achvList) {
    _achvList = achvList;
    notifyListeners();
  }

  loadAchvList() async {
    _repo = AchievementRepository();
    setAchvList = await _repo.loadAchvDataList();
    notifyListeners();
  }

  getAchievement(String id){
    int index = _achvList.indexWhere((achv) => achv.id == id);
     _achv = _achvList[index];
  }

  @override
  void dispose() {
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    super.dispose();
  }
}