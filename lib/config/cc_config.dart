import 'package:flaguiz/models/adventure_completed_model.dart';
import 'package:flaguiz/models/challenge_completed_model.dart';
import 'package:flaguiz/models/user_model.dart';

class CcConfig {

  static String version = '1.0.1';
  static String appName = 'Flaguiz';
  static String companyName = 'CaffeineCup';
  static String companyMail = 'caffeinecup2025.co@gmail.com';
  static bool showLog = false;
  static String image_base_url = 'https://i.postimg.cc';
  static String default_background = '/x8qTz724/bg1.jpg';
  static String WEBSITE_URL = 'https://caffeinecup-flaguiz.netlify.app';
  static String YOUTUBE_URL = 'https://www.youtube.com/channel/UCi-HAqfMdXohP4skT7DriIA';
  static String FACEBOOK_URL = 'https://www.facebook.com/share/1CXtae9kCS';
  static String TIKTOK_URL = 'https://www.tiktok.com/@flaguiz?_r=1&_t=ZN-94qA9tmLIwA';
  static String PRIVACY_AND_POLICY_URL = 'https://caffeinecup-flaguiz.netlify.app/pages/privacy';
  static String TERMS_AND_CONDITIONS_URL = 'https://caffeinecup-flaguiz.netlify.app/pages/terms';

  /// Game Mode
  static String GAME_MODE__FLAG = 'F';
  static String GAME_MODE__MAP = 'M';
  static String GAME_MODE__COUNTRY = 'C';
  static String GAME_MODE__CAPITAL = 'CAP';

  static int GAME_TIMER_COUNT = 20;
  static int ACHIEVEMENT_COIN = 200;

  /// Daily Reward
  static List<int> dailyRewardItems = [20, 40, 60, 80, 100, 150, 200];

  /// Default User
  static UserModel DEFAULT_USER = UserModel(
    id: '',
    playerID: '',
    username: 'Player',
    email: '',
    coin: 0,
    energy: 0,
    trophy: 0,
    achievements: [],
    country: '',
    avatars: ['AVT_001'],
    borders: ['BD_001'],
    backgrounds: ['BG_001'],
    banners: ['BN_001'],
    adventureCompletedList: DEFAULT_ADVENTURE_COMPLETED_LIST,
    challengeCompletedList: DEFAULT_CHALLENGE_COMPLETED_LIST,
    friendIds: [],
    hasPremium: false,
    updatedAt: DateTime.now(),
  );

  /// Default Adventure Completed List
  static List<AdventureCompletedModel> DEFAULT_ADVENTURE_COMPLETED_LIST = [
    AdventureCompletedModel(levelId: '${GAME_MODE__FLAG}_01', life: '0'),
    AdventureCompletedModel(levelId: '${GAME_MODE__MAP}_01', life: '0'),
    AdventureCompletedModel(levelId: '${GAME_MODE__COUNTRY}_01', life: '0'),
    AdventureCompletedModel(levelId: '${GAME_MODE__CAPITAL}_01', life: '0'),
  ];

  /// Default Challenge Completed List
  static List<ChallengeCompletedModel> DEFAULT_CHALLENGE_COMPLETED_LIST = [
    ChallengeCompletedModel(mode: GAME_MODE__FLAG, complete: '0'),
    ChallengeCompletedModel(mode: GAME_MODE__MAP, complete: '0'),
    ChallengeCompletedModel(mode: GAME_MODE__COUNTRY, complete: '0'),
    ChallengeCompletedModel(mode: GAME_MODE__CAPITAL, complete: '0'),
  ];

  /// Hive Box
  static String HIVE_USER_BOX = 'USER-BOX';
  static String HIVE_AVATAR_BOX = 'AVATAR-BOX';
  static String HIVE_BORDER_BOX = 'BORDER-BOX';
  static String HIVE_BACKGROUND_BOX = 'BACKGROUND-BOX';
  static String HIVE_BANNER_BOX = 'BANNER-BOX';
  static String HIVE_COUNTRY_BOX = 'COUNTRY-BOX';
  static String HIVE_DAILY_REWARD_BOX = 'DAILY-REWARD-BOX';

}
