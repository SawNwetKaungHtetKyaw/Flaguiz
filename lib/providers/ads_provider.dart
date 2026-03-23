import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdsProvider extends ChangeNotifier {

  AdsProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    loadAdsBorderProgress();
  }

  int _adsBorderProgressCount = 0;

  int get adsBorderProgressCount => _adsBorderProgressCount;

  set setAdsBorderProgressCount(int count) {
    _adsBorderProgressCount = count;
    addAdsBorderProgress();
    notifyListeners();
  }

  loadAdsBorderProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setAdsBorderProgressCount = int.parse(prefs.getString(CcConstants.ADS_BORDER_PROGRESS) ?? '0');
    notifyListeners();
  }

  addAdsBorderProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(CcConstants.ADS_BORDER_PROGRESS, _adsBorderProgressCount.toString());
  }

  @override
  void dispose() {
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    super.dispose();
  }
}