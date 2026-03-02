import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:hive/hive.dart';

class CountryDao {
  static final String _boxName = CcConfig.HIVE_COUNTRY_BOX;

  // Future<Box<CountryModel>> _openBox() async {
  //   if (!Hive.isBoxOpen(_boxName)) {
  //     return await Hive.openBox<CountryModel>(_boxName);
  //   }
  //   return Hive.box<CountryModel>(_boxName);
  // }

  Future<void> saveCountries(List<CountryModel> list) async {
    final box = await Hive.openBox(_boxName);
    final jsonList = list.map((e) => e.toJson()).toList();
    await box.put('countries', jsonList);
  }

  Future<List<CountryModel>> getCountries() async {
    final box = await Hive.openBox(_boxName);
    final data = box.get('countries', defaultValue: []) as List;
    return data.map((e) => CountryModel.fromJson(Map<String, dynamic>.from(e))).toList();

  }

  Future<bool> hasLocalData() async {
    final box = await Hive.openBox(_boxName);
    return box.containsKey('countries');
  }
}