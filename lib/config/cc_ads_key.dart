class CcAdsKey {
  static String androidAdMobAdsIdKey = 'ca-app-pub-9116233154962039~2763776279';
  static String iosAdMobAdsIdKey = 'ca-app-pub-2551462005480530~6522585821';

  /// Reward Ads Keys
  static const rewardDouble = "reward-double";
  static const rewardContinueGame = "reward-continue-game";
  static const rewardItemProgress = "reward-item-progress";

  static const Map<String, Map<String, String>> rewardedAds = {
    rewardDouble: {
      // "android": "ca-app-pub-3940256099942544/5224354917",
      "android": "ca-app-pub-9116233154962039/7259334724",
      "ios": "ca-app-pub-xxxx/reward_main_ios",
    },
    rewardContinueGame: {
      // "android": "ca-app-pub-3940256099942544/5224354917",
      "android": "ca-app-pub-9116233154962039/7267774283",
      "ios": "ca-app-pub-xxxx/reward_bonus_ios",
    },
    rewardItemProgress: {
      // "android": "ca-app-pub-3940256099942544/5224354917",
      "android": "ca-app-pub-9116233154962039/2488856796",
      "ios": "ca-app-pub-xxxx/reward_bonus_ios",
    },
  };

  /// Banner Ads Keys
  static const bannerLibrary = "banner-library";
  static const bannerAdventure = "banner-adventure";
  static const bannerChallenge = "banner-challenge";
  static const bannerCountryDetail = "banner-country-detail";
  static const bannerShop = "banner-shop";

  static const Map<String, Map<String, String>> bannerAds = {
    bannerAdventure: {
      // "android": "ca-app-pub-3940256099942544/6300978111",
      "android": "ca-app-pub-9116233154962039/4972916881",
      "ios": "ca-app-pub-xxxxxxxx/home_ios",
    },
    bannerChallenge: {
      // "android": "ca-app-pub-3940256099942544/6300978111",
      "android": "ca-app-pub-9116233154962039/5071187485",
      "ios": "ca-app-pub-xxxxxxxx/game_ios",
    },
    bannerShop: {
      // "android": "ca-app-pub-3940256099942544/6300978111",
      "android": "ca-app-pub-9116233154962039/5902855178",
      "ios": "ca-app-pub-xxxxxxxx/result_ios",
    },
    bannerLibrary: {
      // "android": "ca-app-pub-3940256099942544/6300978111",
      "android": "ca-app-pub-9116233154962039/7645379937",
      "ios": "ca-app-pub-xxxxxxxx/profile_ios",
    },
    bannerCountryDetail: {
      // "android": "ca-app-pub-3940256099942544/6300978111",
      "android": "ca-app-pub-9116233154962039/1033671874",
      "ios": "ca-app-pub-xxxxxxxx/shop_ios",
    },
  };
}
