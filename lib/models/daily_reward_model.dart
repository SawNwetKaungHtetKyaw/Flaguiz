class DailyRewardModel {
  int currentDay;
  DateTime? lastClaimDate;

  DailyRewardModel({
    required this.currentDay,
    this.lastClaimDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'currentDay': currentDay,
      'lastClaimDate': lastClaimDate?.toIso8601String(),
    };
  }

  factory DailyRewardModel.fromMap(Map map) {
    return DailyRewardModel(
      currentDay: map['currentDay'],
      lastClaimDate: map['lastClaimDate'] != null
          ? DateTime.parse(map['lastClaimDate'])
          : null,
    );
  }

  factory DailyRewardModel.initial() {
    return DailyRewardModel(currentDay: 1);
  }
}