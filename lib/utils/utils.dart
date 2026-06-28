import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flaguiz/bot/bot_difficulty.dart';
import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/adventure_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/guess_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/service/ads_service.dart';
import 'package:flaguiz/service/cached_image_manager_service.dart';
import 'package:flaguiz/service/firestore_service.dart';
import 'package:flaguiz/widgets/cc_toast_message_widget.dart';
import 'package:flaguiz/widgets/cc_welcome_toast_widget.dart';
import 'package:flaguiz/widgets/dialogs/cc_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static void printLog(Object? object, {bool important = false}) {
    if (CcConfig.showLog & important) {
      // red
      debugPrint('\u001b[31m $object \u001b[0m');
    } else {
      // green
      debugPrint('\u001b[32m $object \u001b[0m');
    }
  }

  static void debugLog(String string) {
    debugPrint('\u001b[35m ====>$string \u001b[0m');
  }

  static Future<void> checkUpdate(BuildContext context) async {
    final newVersion = NewVersionPlus(androidId: "com.caffeinecup.flaguiz");

    final status = await newVersion.getVersionStatus();

    if (status != null) {
      if (status.canUpdate && context.mounted) {
        showUpdateDialog(context, status.storeVersion);
      }
    }
  }

  static void showUpdateDialog(BuildContext context, String storeVersion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CcUpdateDialog(version: storeVersion);
      },
    );
  }

  static Future<String> getImageDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final imageDir = Directory("${dir.path}/country_images");

    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir.path;
  }

  static String fileNameFromUrl(String url) {
    return Uri.parse(url).pathSegments.last;
  }

  static String retureGameMode(int index) {
    late String gameMode;
    switch (index) {
      case 0:
        gameMode = CcConfig.GAME_MODE__FLAG;
        break;
      case 1:
        gameMode = CcConfig.GAME_MODE__COUNTRY;
        break;
      case 2:
        gameMode = CcConfig.GAME_MODE__MAP;
        break;
      case 3:
        gameMode = CcConfig.GAME_MODE__CAPITAL;
        break;
      default:
        gameMode = CcConfig.GAME_MODE__FLAG;
        break;
    }
    return gameMode;
  }

  static List<GuessModel> prepareChallengeGameModeData(
    List<CountryModel> countries,
  ) {
    List<GuessModel> gameGuessList = [];

    for (var guess in countries) {
      GuessModel gameGuess = GuessModel();

      /// Prepare Correct Country
      gameGuess.answer = guess;

      /// Prepare Guess Countries
      gameGuess.countryList = [];
      gameGuess.countryList!.add(guess);

      final random = Random();

      final shuffled = List.of(guess.similarFlags!)..shuffle(random);

      final randomThreeCountries = shuffled.take(3).toList();
      for (var c in randomThreeCountries) {
        CountryModel otherSimilarCountry = countries.firstWhere(
          (country) => country.id == c,
        );
        gameGuess.countryList!.add(otherSimilarCountry);
      }

      gameGuess.countryList!.shuffle();

      gameGuessList.add(gameGuess);
    }

    return gameGuessList;
  }

  static int countStartsWith(List<String> list, String prefix) {
    return list.where((item) => item.startsWith(prefix)).length;
  }

  static List<GuessModel> prepareAdventureGameModeData(
    AdventureModel adventureModel,
    List<CountryModel> countries,
  ) {
    List<GuessModel> gameGuessList = [];
    adventureModel.guessList!.shuffle();
    for (var guess in adventureModel.guessList!) {
      GuessModel gameGuess = GuessModel();

      /// Prepare Correct Country
      CountryModel correctCountry = countries.firstWhere(
        (country) => country.id == guess,
      );
      gameGuess.answer = correctCountry;

      /// Prepare Guess Countries
      gameGuess.countryList = [];
      gameGuess.countryList!.add(correctCountry);

      final random = Random();

      final shuffled = List.of(correctCountry.similarFlags!)..shuffle(random);

      final randomThreeCountries = shuffled.take(3).toList();

      for (var c in randomThreeCountries) {
        CountryModel otherSimilarCountry = countries.firstWhere(
          (country) => country.id == c,
        );
        gameGuess.countryList!.add(otherSimilarCountry);
      }

      gameGuess.countryList!.shuffle();

      gameGuessList.add(gameGuess);
    }

    return gameGuessList;
  }

  static ImageProvider<Object> checkImageType(String path) {
    if (path.startsWith('http')) {
      // Network image
      return CachedNetworkImageProvider(
        path,
        cacheManager: CachedImageManagerService(),
      );
    } else if (path.startsWith('/data') ||
        path.startsWith('/storage') ||
        File(path).existsSync()) {
      // Local File image
      return FileImage(File(path));
    } else {
      // Asset image
      return AssetImage(path);
    }
  }

  static void showToastMessage(
    BuildContext context,
    String message, {
    Color? textColor,
    Color? backgroundColor,
  }) {
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => CcToastMessageWidget(
            message: message,
            onFinish: () => overlayEntry.remove(),
            textColor: textColor ?? Colors.white,
            backgroundColor: backgroundColor ?? Colors.black87,
          ),
    );

    overlay.insert(overlayEntry);
  }

  static void showWelcomToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => CcWelcomeToastWidget(
            message: message,
            onFinish: () => overlayEntry.remove(),
          ),
    );

    overlay.insert(overlayEntry);
  }

  static String getPremiumTimeLeft(DateTime? expireDate) {
    if (expireDate == null) return "Expired";

    final now = DateTime.now();
    final difference = expireDate.difference(now);

    // If the expiration date is in the past
    if (difference.isNegative) {
      return "Expired";
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24; // Get remaining hours after days

    if (days > 0) {
      return "$days ${days == 1 ? 'day' : 'days'} $hours ${hours == 1 ? 'hr' : 'hrs'} left";
    } else if (hours > 0) {
      return "$hours ${hours == 1 ? 'hr' : 'hrs'} left";
    } else {
      final minutes = difference.inMinutes % 60;
      return "$minutes ${minutes == 1 ? 'min' : 'mins'} left";
    }
  }

  static Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> areImagesCached(List<String> urls) async {
    final cacheManager = CachedImageManagerService();

    final results = await Future.wait(
      urls.map((url) => cacheManager.getFileFromCache(url)),
    );

    return !results.contains(null);
  }

  static Future<void> openLink(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) showToastMessage(context, "Couldn't launch $url");
    }
  }

  static String getBannerAdUnitId(String key) {
    return Platform.isAndroid
        ? CcAdsKey.bannerAds[key]!["android"]!
        : CcAdsKey.bannerAds[key]!["ios"]!;
  }

  static String getRewardedAdUnitId(String key) {
    return Platform.isAndroid
        ? CcAdsKey.rewardedAds[key]!["android"]!
        : CcAdsKey.rewardedAds[key]!["ios"]!;
  }

  static String getInterstitialAdUnitId(String key) {
    return Platform.isAndroid
        ? CcAdsKey.interstitialAds[key]!["android"]!
        : CcAdsKey.interstitialAds[key]!["ios"]!;
  }

  static void preLoadRewardedAds(String key) {
    AdsService.instance.loadRewardedAds(key);
  }

  static Future<void> openSendMail(BuildContext context) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: CcConfig.companyMail);

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (context.mounted) {
        showToastMessage(context, "Couldn't launch ${CcConfig.companyMail}");
      }
    }
  }

  static String generateId() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();

    return String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  static List<UserModel> sortFriends(List<UserModel> friends) {
    friends.sort((a, b) {
      final aOnline = a.isOnline ?? false;
      final bOnline = b.isOnline ?? false;

      // online first
      if (aOnline && !bOnline) {
        return -1;
      }

      if (!aOnline && bOnline) {
        return 1;
      }

      // optional:
      // latest active first
      final aLastSeen = a.lastSeen ?? DateTime(2000);
      final bLastSeen = b.lastSeen ?? DateTime(2000);

      return bLastSeen.compareTo(aLastSeen);
    });

    return friends;
  }

  static Future<String> generateUniqueId() async {
    String id;
    bool exists = true;
    FirestoreService firestore = FirestoreService();

    do {
      id = "#${generateId()}";
      exists = await firestore.checkIdExists(id);
    } while (exists);

    return id;
  }

  static String getLastSeen(DateTime? lastSeen) {
    if (lastSeen == null) return "Offline";

    final diff = DateTime.now().difference(lastSeen);

    // Seconds
    if (diff.inSeconds < 60) {
      return "${diff.inSeconds} sec ago";
    }

    // Minutes
    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    }

    // Hours
    if (diff.inHours < 24) {
      return "${diff.inHours} hour${diff.inHours > 1 ? "s" : ""} ago";
    }

    // Days
    if (diff.inDays < 365) {
      return "${diff.inDays} day${diff.inDays > 1 ? "s" : ""} ago";
    }

    // Years
    final years = (diff.inDays / 365).floor();

    return "$years year${years > 1 ? "s" : ""} ago";
  }

  static Future<void> preloadImages(
    BuildContext context,
    List<String?> images,
  ) async {
    final uniqueImages = images.toSet();
    await Future.wait(
      uniqueImages.map(
        (url) => precacheImage(
          CachedNetworkImageProvider(
            "${CcConfig.image_base_url}$url",
            cacheManager: CachedImageManagerService(),
          ),
          context,
        ),
      ),
    );
  }

  static int botTrophy(int trophy) {
    final Random random = Random();
    if (trophy < 200) {
      return random.nextInt(200);
    } else if (trophy < 400) {
      return random.nextInt(200) + 200;
    } else if (trophy < 800) {
      return random.nextInt(400) + 400;
    } else if (trophy < 1600) {
      return random.nextInt(800) + 800;
    } else {
      return random.nextInt(trophy - 500 + 1) + 500;
    }
  }

  static int battleDifficultyByTrophy(int trophy) {
    if (trophy < 200) {
      return 1;
    } else if (trophy < 400) {
      return 2;
    } else if (trophy < 800) {
      return 3;
    } else if (trophy < 1600) {
      return 4;
    } else {
      return 5;
    }
  }

  static BotDifficulty botDifficultyByTrophy(int trophy) {
    if (trophy < 200) {
      return BotDifficulty.newbie;
    } else if (trophy < 400) {
      return BotDifficulty.newbie;
    } else if (trophy < 800) {
      return BotDifficulty.medium;
    } else if (trophy < 1600) {
      return BotDifficulty.hard;
    } else {
      return BotDifficulty.pro;
    }
  }

  static int calculateLosePenalty(int trophy) {
    if (trophy <= 0) return 0;
    if (trophy <= 1) return 1;
    if (trophy <= 2) return 2;

    double percent = 0.05;
    int loss = (trophy * percent).round();

    if (loss < 3) loss = 3;

    if (loss > 20) loss = 20;

    if (loss > trophy) loss = trophy;

    return loss;
  }

  static int battleCoinByResult(String result) {
    int coin = 0;
    if (result == CcConstants.BATTLE_WIN) {
      coin = 20;
    } else if (result == CcConstants.BATTLE_LOSE) {
      coin = 5;
    } else {
      coin = 10;
    }
    return coin;
  }

  static int battleTrophyByResult(String result, int userTrophy) {
    int trophy = 0;
    if (result == CcConstants.BATTLE_WIN) {
      trophy = 10;
    } else if (result == CcConstants.BATTLE_LOSE) {
      trophy = -calculateLosePenalty(userTrophy);
    } else {
      trophy = 5;
    }
    return trophy;
  }

  static String formatNumber(num number) {
    if (number >= 1000000000) {
      return _format(number / 1000000000, 'B');
    } else if (number >= 1000000) {
      return _format(number / 1000000, 'M');
    } else if (number >= 1000) {
      return _format(number / 1000, 'K');
    }

    return number.toString();
  }

  static String _format(num value, String suffix) {
    String text = value.toStringAsFixed(2);

    text = text.replaceFirst(RegExp(r'\.?0+$'), '');

    return '$text$suffix';
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
