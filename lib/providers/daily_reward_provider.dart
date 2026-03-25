import 'package:flaguiz/models/daily_reward_model.dart';
import 'package:flaguiz/repositories/daily_reward_repository.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class DailyRewardProvider extends ChangeNotifier {
  DailyRewardProvider({required BuildContext buildContext}) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    _repo = initRepo(buildContext);
  }

  static DailyRewardRepository initRepo(BuildContext context) {
    return DailyRewardRepository();
  }

  initReward() async {
    reward = await _repo.getReward();
    notifyListeners();
  }

  late DailyRewardRepository _repo;
  DailyRewardModel? reward;

  bool get canClaim => reward != null && _repo.canClaim(reward!);

  Future<int> claim() async {
    if (reward == null) return 0;

    int coins = await _repo.claimReward(reward!);
    notifyListeners();
    return coins;
  }

  Future<void> clear()async{
    reward = null;
    _repo.clear();
    initReward();
    notifyListeners();
  }

  @override
  void dispose() {
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    super.dispose();
  }
}
