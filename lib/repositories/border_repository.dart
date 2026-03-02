import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/databases/border_dao.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class BorderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BorderDao _dao = BorderDao();

  void startSync() {
    _firestore.collection(CcConstants.FIRESTORE_BORDER).snapshots().listen((snapshot) {

      for (final change in snapshot.docChanges) {
        final data = change.doc.data();
        if (data == null) continue;

        final item = ShopModel.fromJson(data);

        switch (change.type) {

          case DocumentChangeType.added:
          case DocumentChangeType.modified:
            put(item);
            break;

          case DocumentChangeType.removed:
            delete(item.id!);
            break;
        }
      }
    });
  }

  List<ShopModel> getAll() {
    return _dao.getAll();
  }

  /// Get by id
  ShopModel? getById(String id) {
    return _dao.getById(id);
  }

  Future<void> put(ShopModel item) async {
    await _dao.put(item);
  }

  Future<void> delete(String id) async {
    await _dao.delete(id);
  }

  Future<void> clear() async {
    await _dao.clear();
  }

  ValueListenable<Box<ShopModel>> listenable() {
    return _dao.listenable();
  }
}