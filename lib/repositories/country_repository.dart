import 'dart:convert';

import 'package:flaguiz/databases/country_dao.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/service/country_image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryRepository {
  CountryRepository();

  final CountryDao _dao = CountryDao();
  final CountryService _service = CountryService();

  /// Download Section
  Future<List<CountryModel>> syncCountries(
      List<CountryModel> countryList) async {
    return await _service.syncCountries(countryList);
  }

  /// Cached Section
  Future<void> preload(
    BuildContext context,
    List<CountryModel> countryList,
    Function(double) onProgress,
  ) {
    return _service.preloadImages(
      context: context,
      countryList: countryList,
      onProgress: onProgress,
    );
  }

  //// Load Country json
  Future<List<CountryModel>> loadDataList() async {
    final String response =
        await rootBundle.loadString('assets/json/countries.json');

    final List<dynamic> data = json.decode(response);

    final List<CountryModel> countryList = data
        .map((e) => CountryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    countryList.sort((a, b) => a.name!.compareTo(b.name!));

    return countryList;
  }

  ///// Local Storage Section
  Future<void> saveCountries(List<CountryModel> list) async {
    await _dao.saveCountries(list);
  }

  Future<List<CountryModel>> getCountries() async {
    return _dao.getCountries();
  }

  Future<void> updateCountry(CountryModel country) async {
    await _dao.updateCountry(country);
  }

  Future<CountryModel?> getById(String id) async {
    return await _dao.getById(id);
  }

  Future<bool> hasLocalData() async {
    return await _dao.hasLocalData();
  }
}
