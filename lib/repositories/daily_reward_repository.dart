import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/databases/daily_reward_dao.dart';
import 'package:flaguiz/models/daily_reward_model.dart';

class DailyRewardRepository {
  final DailyRewardDao _dao = DailyRewardDao();

  DailyRewardRepository();

  Future<DailyRewardModel> getReward() async {
    return await _dao.getReward();
  }

  bool canClaim(DailyRewardModel reward) {
  if (reward.lastClaimDate == null) return true;

  final now = DateTime.now();

  final last = DateTime(
    reward.lastClaimDate!.year,
    reward.lastClaimDate!.month,
    reward.lastClaimDate!.day,
  );

  final today = DateTime(now.year, now.month, now.day);

  final difference = today.difference(last).inDays;

  // If cycle finished and new day → allow reset
  if (reward.currentDay == 7 && difference >= 1) {
    reward.currentDay = 0; // reset internally
    return true;
  }

  return difference >= 1;
}

  Future<int> claimReward(DailyRewardModel reward) async {
  final now = DateTime.now();

  if (!canClaim(reward)) return 0;

  if (reward.lastClaimDate == null) {
    reward.currentDay = 1;
  } else {
    if (reward.currentDay < 7) {
      reward.currentDay += 1;
    } 
  }

  int coins = CcConfig.dailyRewardItems[reward.currentDay - 1];

  reward.lastClaimDate = now;

  await _dao.saveReward(reward);

  return coins;
}
}
