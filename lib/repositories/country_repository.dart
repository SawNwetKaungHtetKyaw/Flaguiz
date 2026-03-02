import 'dart:convert';

import 'package:flaguiz/databases/country_dao.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flutter/services.dart';

class CountryRepository {
  CountryRepository();

  final CountryDao _dao = CountryDao();

  Future<dynamic> loadDataList() async {
    final String response =
        await rootBundle.loadString('assets/json/countries.json');
    final data = await json.decode(response);
    List list = data as List;
    List<CountryModel> countryList =
        list.map((e) => CountryModel.fromJson(e)).toList();
    countryList.sort((a, b) => a.name!.compareTo(b.name!));
    return countryList;
  }

  Future<CountryModel> loadDataById(String id) async {
    late CountryModel countryModel;
    List<CountryModel> list = await loadDataList();
    for (var country in list) {
      if (country.id == id) {
        countryModel = country;
      }
    }
    return countryModel;
  }

  Future<List<CountryModel>> getCountries() async {
    if (await _dao.hasLocalData()) {
      return await _dao.getCountries();
    }

    List<CountryModel> apiData = await loadDataList();
    await _dao.saveCountries(apiData);
    return apiData;
  }

  // Future<void> downloadAllImagesWithProgress({
  //   required Function(double progress) onProgress,
  // }) async {
  //   List<CountryModel> countries = await _dao.getCountries();
  //   int total = countries.length * 2;
  //   int completed = 0;

  //   for (var country in countries) {
  //     final flagPath = await _imageService.downloadImageWithProgress(
  //       "${CcConfig.image_base_url}${country.flagUrl}",
  //       "${country.id}_flag.jpg",
  //       (received, totalBytes) {},
  //     );
  //     onProgress(++completed / total);
  //     if (flagPath != null) {
  //       country.flagUrl = flagPath;
  //     }else{
  //       country.flagUrl = "${CcConfig.image_base_url}${country.flagUrl}";
  //     }

  //     final mapPath = await _imageService.downloadImageWithProgress(
  //       "${CcConfig.image_base_url}${country.mapUrl}",
  //       "${country.id}_map.jpg",
  //       (received, totalBytes) {},
  //     );
  //     onProgress(++completed / total);
  //     if (mapPath != null) {
  //       country.mapUrl = mapPath;
  //     } else {
  //       country.mapUrl = "${CcConfig.image_base_url}${country.mapUrl}";
  //     }
  //   }

  //   await _dao.saveCountries(countries);
  // }
}
