import 'package:flaguiz/utils/asset_images.dart';

class CcConstants {

  CcConstants._();

  static const String kCompanyName = 'Caffeine Cup';
  static const String kAppName = 'Flaguiz';
  static const String kAdventure = 'Adventure';
  static const String kAdventureStatus = 'Adventure Status';
  static const String kChallenge = 'Challenge';
  static const String kChallengeStatus = 'Challenge Status';
  static const String kLibrary = 'Library';
  static const String kBattle = 'Battle';
  static const String kShop = 'Shop';
  static const String kEnter = 'Enter';
  static const String kSearch = 'Search';
  static const String kSetting = 'Setting';
  static const String kRegion = 'Region';
  static const String kCurrency = 'Currency';
  static const String kCapital = 'Capital';
  static const String kHint = 'Hint';
  static const String kFLAG = 'Flag';
  static const String kMAP = 'Map';
  static const String kCOUNTRY = 'Country';
  static const String kCAPITAL = 'Capital';
  static const String kYouLose = 'You Lose';
  static const String kYouWin = 'You Win';
  static const String kGiveUp = 'Give Up';
  static const String kPlayAgain = 'Play Again';
  static const String kPlayOn = 'Play On';
  static const String kAds = 'Ads';
  static const String kEdit = 'Edit';
  static const String kLogin = 'Login';
  static const String kRegister = 'Register';
  static const String kDoubleReward = 'Double Reward x2';
  static const String kAchievement = 'Achievement';
  static const String kOwned = 'Owned';
  static const String kVolume = 'Volume';
  static const String kMusic = 'Music';
  static const String kPrivacyPolicies = 'Privacy & Policies';
  static const String kAbout = 'About';
  static const String kClose = 'Close';
  static const String kChooseCountry = 'Choose Country';
  static const String kDailyReward = 'Daily Reward';
  static const String kClaim = 'Claim';
  static const String kClaim2x = 'Claim 2x';

  /// Hero Tag Keys
  static const String kH_GAME_MODE = 'hero-game-mode';
  static const String kH_SHOP_AVATAR = 'shop-avatar';
  static const String kH_SHOP_BORDER = 'shop-border';
  static const String kH_SHOP_BACKGROUND = 'shop-background';
  static const String kH_SHOP_BANNER = 'shop-banner';

  /// Firebase
  static const String FIRESTORE_AVATAR = 'Avatars';
  static const String FIRESTORE_BORDER = 'Borders';
  static const String FIRESTORE_BACKGROUND = 'Backgrounds';
  static const String FIRESTORE_BANNER = 'Banners';

  /// Shared Preferences Constants
  static const String ISUSERLOGIN = 'IS_USER_LOGIN';
  static const String IS_SOUND_ON = 'IS_SOUND_ON';
  static const String IS_MUSIC_ON = 'IS_MUSIC_ON';
  static const String KEEN_EYE = 'KEEN_EYE';

  /// Preload image
  static final List<String> preLoadImages = [
    AssetsImages.adventure,
    AssetsImages.adventureBg,
    AssetsImages.battle,
    AssetsImages.battleBg,
    AssetsImages.challenge,
    AssetsImages.challengeBg,
    AssetsImages.challengeButton,
    AssetsImages.libraryBg,
    AssetsImages.enterButton,
    AssetsImages.libraryButton,
    AssetsImages.shopButton,
    AssetsImages.energyBox,
    AssetsImages.coinBox,
    AssetsImages.adventureBackKey,
    AssetsImages.challengeBackKey,
    AssetsImages.defaultBackground,
  ];

  /// Toast Msg Constant
  static const String enoughCoin = "Enough Coin";

  static const String lorem = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.";

}