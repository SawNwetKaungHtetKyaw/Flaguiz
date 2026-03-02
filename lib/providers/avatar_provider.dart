
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/repositories/avatar_repository.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AvatarProvider extends ChangeNotifier {
  AvatarProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    _repo = initRepo(buildContext);
  }

  static AvatarRepository initRepo(BuildContext context) {
    return AvatarRepository();
  }

  late AvatarRepository _repo;
  ShopModel? avatar;

  getById(String id) async{
    avatar = _repo.getById(id);
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
