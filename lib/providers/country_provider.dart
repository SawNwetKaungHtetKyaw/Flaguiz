import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/repositories/country_repository.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryProvider extends ChangeNotifier {
  CountryProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    loadCountryList();
    loadKeenEye();
  }

  late CountryRepository _repo;
  List<CountryModel> _countryList = [];
  List<CountryModel> _filteredCountryList = [];
  double downloadProgress = 0.0;
  List<String> _keenEyeList = [];

  List<CountryModel> get countryList => _countryList;
  List<CountryModel> get filteredCountryList => _filteredCountryList;
  List<String> get keenEyeList => _keenEyeList;

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

  loadCountryList() async {
    _repo = CountryRepository();
    setCountryList = await _repo.loadDataList();
    setFilteredCountryList = _countryList;
    notifyListeners();
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

  /// Load data from local or API (first time only)
  Future<void> loadCountries() async {
    _countryList = await _repo.getCountries();
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
    if (countryId != '' && _countryList != []) {
      final int index =
          _countryList.indexWhere((country) => country.id == countryId);
      return _countryList[index];
    } else {
      return null;
    }
  }

  // /// Download all images and update progress
  // Future<void> downloadImages() async {
  //   notifyListeners();

  //   await _repo.downloadAllImagesWithProgress(
  //     onProgress: (progress) {
  //       downloadProgress = progress; // update progress (0-1)
  //       notifyListeners();
  //     },
  //   );

  //   // 🔹 Refresh list after updating local paths
  //   _countryList = await _repo.getCountries();
  //   notifyListeners();
  // }

  /// Full setup process (first run / loading screen)
  // Future<void> setupApp() async {
  //   await loadCountries();   // Load models first
  //   await downloadImages();  // Then download images once
  // }

  @override
  void dispose() {
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    super.dispose();
  }
}
