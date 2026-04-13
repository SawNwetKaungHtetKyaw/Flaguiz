import 'dart:async';

import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/repositories/country_repository.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryProvider extends ChangeNotifier {
  CountryProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    loadKeenEye();
  }

  final CountryRepository _repo = CountryRepository();
  List<CountryModel> _countryList = [];
  List<CountryModel> _filteredCountryList = [];
  List<String> _keenEyeList = [];
  double _progress = 0.0;
  bool isLoading = false;
  Timer? _progressTimer;

  List<CountryModel> get countryList => _countryList;
  List<CountryModel> get filteredCountryList => _filteredCountryList;
  List<String> get keenEyeList => _keenEyeList;
  double get progress => _progress;

  set setCountryList(List<CountryModel> countryList) {
    _countryList = countryList;
    notifyListeners();
  }

  set setFilteredCountryList(List<CountryModel> filteredCountryList) {
    _filteredCountryList = filteredCountryList;
    notifyListeners();
  }

  set setKeenEyeList(List<String> keenEyeList) {
    _keenEyeList = keenEyeList;
    notifyListeners();
  }

  Future<void> syncCountries() async {
    try {
      _countryList = await loadDataList();
      _countryList = await _repo.syncCountries(_countryList);
    } catch (e) {
      _countryList = await loadDataList();
      debugPrint("Sync error ===>$e");
    }
  }

  //// Cached Image Section
  Future<void> startCachedCountryImage(
    BuildContext context,
  ) async {
    List<CountryModel> temp = await _repo.loadDataList();

    if (!context.mounted) return;
    await _repo.preload(
      context,
      temp,
      (progress) {
        _progress = progress;
        notifyListeners();
      },
    );
  }

  Future<List<CountryModel>> loadDataList() async {
    return await _repo.loadDataList();
  }

  loadKeenEye() async {
    final prefs = await SharedPreferences.getInstance();
    setKeenEyeList = prefs.getStringList(CcConstants.KEEN_EYE) ?? [];
    notifyListeners();
  }

  addKeenKye() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(CcConstants.KEEN_EYE, _keenEyeList);
  }

  /// Filtered List
  filteredSearchList(String searchTerm) {
    setFilteredCountryList = countryList
        .where((country) =>
            country.name!.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<CountryModel?> countryById(String countryId) async {
    if (countryId != '0' && _countryList != []) {
      final int index =
          _countryList.indexWhere((country) => country.id == countryId);
      return _countryList[index];
    } else {
      return null;
    }
  }

  Future<bool> isDownloaded() async {
    final temp = await _repo.getCountries();

    if (temp.isEmpty) {
      return false;
    }

    return !temp.any((country) =>
        country.localFlagPath == null || country.localMapPath == null);
  }

  void animateToFullProgress() {
    _progressTimer?.cancel();

    const int durationMs = 2000;
    const int tickMs = 50;

    const int totalTicks = durationMs ~/ tickMs;
    int currentTick = 0;

    _progressTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) {
        currentTick++;

        _progress = (currentTick / totalTicks).clamp(0.0, 1.0);

        notifyListeners();

        if (currentTick >= totalTicks) {
          _progress = 1.0;
          notifyListeners();
          timer.cancel();
        }
      },
    );
  }

  Future<void> getCountries() async {
    _countryList = await _repo.getCountries();
    notifyListeners();
  }

  @override
  void dispose() {
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    super.dispose();
  }
}
