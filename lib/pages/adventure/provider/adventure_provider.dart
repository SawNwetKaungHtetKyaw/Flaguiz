import 'package:flaguiz/models/adventure_model.dart';
import 'package:flaguiz/repositories/adventure_repository.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class AdventureProvider extends ChangeNotifier {

  AdventureProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    loadCountryList();
  }

  late AdventureRepository _repo;
  List<AdventureModel> _levelList = [];

  List<AdventureModel> get levelList => _levelList;

  set setLevelList(List<AdventureModel> levelList) {
    _levelList = levelList;
    notifyListeners();
  }

  loadCountryList() async {
    _repo = AdventureRepository();
    setLevelList = await _repo.loadDataList();
    notifyListeners();
  }

  @override
  void dispose() {
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    super.dispose();
  }
}