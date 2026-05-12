import 'package:flaguiz/models/country_leaderboard_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/repositories/leaderboard_repository.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class LeaderboardProvider extends ChangeNotifier {
  LeaderboardProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    _repo = initRepo(buildContext);
  }

  static LeaderboardRepository initRepo(BuildContext context) {
    return LeaderboardRepository();
  }

  late LeaderboardRepository _repo;

  Future<List<UserModel>> getLocalLeaderBoard(String countryId) async {
    return _repo.getLocalLeaderBoard(countryId);
  }

  Future<List<UserModel>> getGlobalLeaderBoard() async {
    return _repo.getGlobalLeaderBoard();
  }

  Future<List<CountryLeaderboardModel>> getCountryLeaderboard() async {
    return _repo.getCountryLeaderboard();
  }

  @override
  void dispose() {
    Utils.printLog(
      '${runtimeType.toString()} Dispose $hashCode',
      important: true,
    );
    super.dispose();
  }
}
