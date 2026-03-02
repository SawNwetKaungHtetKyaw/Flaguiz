import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BannerDao {
  static final String _boxName = CcConfig.HIVE_BANNER_BOX;

  Box<ShopModel> get _box => Hive.box<ShopModel>(_boxName);

  /// Get all
  List<ShopModel> getAll() {
    return _box.values.toList();
  }

  /// Get by id
  ShopModel? getById(String id) {
    return _box.get(id);
  }

  /// Insert or update
  Future<void> put(ShopModel item) async {
    await _box.put(item.id, item);
  }

  /// Delete
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Clear all (optional)
  Future<void> clear() async {
    await _box.clear();
  }

  /// Watch changes (for UI auto update)
  ValueListenable<Box<ShopModel>> listenable() {
    return _box.listenable();
  }
}
