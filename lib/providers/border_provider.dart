
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/repositories/border_repository.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BorderProvider extends ChangeNotifier {
  BorderProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    _repo = initRepo(buildContext);
  }

  static BorderRepository initRepo(BuildContext context) {
    return BorderRepository();
  }

  late BorderRepository _repo;
  ShopModel? border;

  getById(String id) async{
    border = _repo.getById(id);
  }
  
  List<ShopModel> getAll() {
    return _repo.getAll();
  }

  Future<void> put(ShopModel item) async {
    await _repo.put(item);
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
  }

  Future<void> clear() async {
    await _repo.clear();
  }

  ValueListenable<Box<ShopModel>> listenable() {
    return _repo.listenable();
  }

  @override
  void dispose() {
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    super.dispose();
  }
}
