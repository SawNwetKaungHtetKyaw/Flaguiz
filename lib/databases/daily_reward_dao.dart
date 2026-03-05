import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/daily_reward_model.dart';
import 'package:hive/hive.dart';

class DailyRewardDao {
  static final String boxName = CcConfig.HIVE_DAILY_REWARD_BOX;
  static const String key = 'dailyReward';

  Future<Box> _openBox() async {
    return await Hive.openBox(boxName);
  }

  Future<DailyRewardModel> getReward() async {
    final box = await _openBox();
    final map = box.get(key);

    if (map == null) {
      return DailyRewardModel(currentDay: 0);
    }

    return DailyRewardModel.fromMap(Map<String, dynamic>.from(map));
  }

  Future<void> saveReward(DailyRewardModel reward) async {
    final box = await _openBox();
    await box.put(key, reward.toMap());
  }

  Future<void> clear() async {
    final box = await _openBox();
    await box.delete(key);
  }
}