
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/databases/user_dao.dart';
import 'package:flaguiz/models/user_model.dart';

class UserRepository {

  UserRepository();

  final UserDao _userDao = UserDao();

  Future<UserModel> createOrGetUser() async {
    final existingUser = await _userDao.getUser();
    if (existingUser != null) return existingUser;

    print("user is null");

    await _userDao.updateUser(CcConfig.DEFAULT_USER);
    return CcConfig.DEFAULT_USER;
  }

  Future<UserModel?> getUser() => _userDao.getUser();

  Future<void> updateUser(UserModel user) => _userDao.updateUser(user);

  Future<void> deleteUser() => _userDao.deleteUser();
}
