import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider() {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void next() {
    _currentIndex = (_currentIndex + 1) % 3; // loop
    notifyListeners();
  }

  void previous() {
    _currentIndex = (_currentIndex - 1 + 3) % 3; // loop backwards
    notifyListeners();
  }

  @override
  void dispose() {
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    super.dispose();
  }
}
