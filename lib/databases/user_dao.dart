import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:hive/hive.dart';

class UserDao {
   static final String boxName = CcConfig.HIVE_USER_BOX;

  Future<Box<UserModel>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<UserModel>(boxName);
    }
    return Hive.box<UserModel>(boxName);
  }

  Future<void> updateUser(UserModel user) async {
    final box = await _openBox();
    await box.put('user', user);
  }

  Future<UserModel?> getUser() async {
    final box = await _openBox();
    return box.get('user');
  }

  Future<void> deleteUser() async {
    final box = await _openBox();
    await box.delete('user');
  }

  Future<bool> hasUser() async {
    final box = await _openBox();
    return box.containsKey('user');
  }
}
