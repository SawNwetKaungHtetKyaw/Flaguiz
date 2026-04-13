import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:hive/hive.dart';

class CountryDao {
  static final String _boxName = CcConfig.HIVE_COUNTRY_BOX;

  Future<Box> _openBox() => Hive.openBox(_boxName);

  Future<void> saveCountries(List<CountryModel> list) async {
    final box = await _openBox();
    final jsonList = list.map((e) => e.toJson()).toList();
    await box.put('countries', jsonList);
  }

  Future<List<CountryModel>> getCountries() async {
    final box = await Hive.openBox(_boxName);

    final data = box.get('countries', defaultValue: []) as List;

    return data.map((e) {
      return CountryModel.fromJson(
        Map<String, dynamic>.from(e),
      );
    }).toList();
  }

  Future<void> updateCountry(CountryModel country) async {
    final box = await _openBox();
    List<CountryModel> list =
        (box.get('countries', defaultValue: []) as List).cast<CountryModel>();

    final index = list.indexWhere((e) => e.id == country.id);
    if (index != -1) {
      list[index] = country;
      await box.put('countries', list);
    }
  }

  Future<CountryModel?> getById(String id) async {
    final box = await Hive.openBox(_boxName);
    final data = box.get('countries', defaultValue: []) as List;

    try {
      final json = data.firstWhere((e) => e['id'] == id);
      return CountryModel.fromJson(Map<String, dynamic>.from(json));
    } catch (e) {
      return null;
    }
  }

  Future<bool> hasLocalData() async {
    final box = await _openBox();
    return box.containsKey('countries');
  }
}
