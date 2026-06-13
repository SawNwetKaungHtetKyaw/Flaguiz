import 'package:flaguiz/bot/bot_difficulty.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/models/guess_model.dart';
import 'package:flaguiz/pages/about/about.dart';
import 'package:flaguiz/pages/adventure/adventure.dart';
import 'package:flaguiz/pages/adventure/adventure_level.dart';
import 'package:flaguiz/pages/battle/battle.dart';
import 'package:flaguiz/pages/battle_challenge/battle_challenge.dart';
import 'package:flaguiz/pages/battle_challenge_game/battle_challenge_game.dart';
import 'package:flaguiz/pages/battle_challenge_intro/battle_challenge_intro.dart';
import 'package:flaguiz/pages/battle_challenge_result/battle_challenge_result.dart';
import 'package:flaguiz/pages/battle_game/battle_game.dart';
import 'package:flaguiz/pages/battle_game_result/battle_game_result.dart';
import 'package:flaguiz/pages/battle_intro/battle_intro.dart';
import 'package:flaguiz/pages/challenge/challenge.dart';
import 'package:flaguiz/pages/challenge_game/challenge_game_by_image.dart';
import 'package:flaguiz/pages/challenge_game/challenge_game_by_text.dart';
import 'package:flaguiz/pages/challenge_victory/challenge_victory.dart';
import 'package:flaguiz/pages/country_detail/country_detail.dart';
import 'package:flaguiz/pages/adventure_game/adventure_game_by_image.dart';
import 'package:flaguiz/pages/adventure_game/adventure_game_by_text.dart';
import 'package:flaguiz/pages/friends/friends.dart';
import 'package:flaguiz/pages/home/home.dart';
import 'package:flaguiz/pages/leaderboard/leaderboard.dart';
import 'package:flaguiz/pages/library/library.dart';
import 'package:flaguiz/pages/loading/loading.dart';
import 'package:flaguiz/pages/privacy_policies/privacy_policies.dart';
import 'package:flaguiz/pages/profile/profile.dart';
import 'package:flaguiz/pages/adventure_victory/adventure_victory.dart';
import 'package:flaguiz/pages/shop/shop.dart';
import 'package:flaguiz/pages/shop_detail/shop_detail.dart';
import 'package:flaguiz/pages/terms_conditions/terms_conditions.dart';
import 'package:flutter/material.dart';

import '../../pages/splash_screen/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings setting) {
  switch (setting.name) {
    case '/':
      return MaterialPageRoute<dynamic>(
        builder: (BuildContext context) {
          return const SplashScreen();
        },
      );
    case RoutePaths.loading:
      return AnimationRoute.scale(settings: setting, page: const Loading());
    case RoutePaths.home:
      return MaterialPageRoute(
        settings: const RouteSettings(name: RoutePaths.home),
        builder: (BuildContext context) {
          return const Home();
        },
      );
    case RoutePaths.profile:
      return AnimationRoute.scale(settings: setting, page: const Profile());
    case RoutePaths.about:
      return AnimationRoute.scale(settings: setting, page: const About());
    case RoutePaths.privacyPolicies:
      return AnimationRoute.scale(
        settings: setting,
        page: const PrivacyPolicies(),
      );
    case RoutePaths.termsConditions:
      return AnimationRoute.scale(
        settings: setting,
        page: const TermsConditions(),
      );
    case RoutePaths.shop:
      return AnimationRoute.scale(settings: setting, page: const Shop());
    case RoutePaths.shopDetail:
      final Object? args = setting.arguments;
      final String category = (args as String? ?? String) as String;
      return AnimationRoute.scale(
        settings: setting,
        page: ShopDetail(category: category),
      );
    case RoutePaths.adventure:
      return MaterialPageRoute(
        settings: const RouteSettings(name: RoutePaths.adventure),
        builder: (BuildContext context) {
          return const Adventure();
        },
      );
    case RoutePaths.adventureLevel:
      final args = setting.arguments as String?;
      return PageRouteBuilder(
        settings: const RouteSettings(name: RoutePaths.adventureLevel),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, _, _) => AdventureLevel(mode: args ?? ''),
      );
    case RoutePaths.adventureGameByImage:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final List<GuessModel> guessList = args[0] ?? [];
      final String mode = args[1];
      final String levelId = args[2];
      return PageRouteBuilder(
        settings: const RouteSettings(name: RoutePaths.adventureGameByImage),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder:
            (_, _, _) => AdventureGameByImage(
              guessList: guessList,
              mode: mode,
              levelId: levelId,
            ),
      );
    case RoutePaths.adventureGameByText:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final List<GuessModel> guessList = args[0] ?? [];
      final String mode = args[1];
      final String levelId = args[2];
      return PageRouteBuilder(
        settings: const RouteSettings(name: RoutePaths.adventureGameByText),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder:
            (_, _, _) => AdventureGameByText(
              guessList: guessList,
              mode: mode,
              levelId: levelId,
            ),
      );
    case RoutePaths.challenge:
      return MaterialPageRoute(
        settings: const RouteSettings(name: RoutePaths.challenge),
        builder: (BuildContext context) {
          return const Challenge();
        },
      );
    case RoutePaths.challengeGameByImage:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final List<GuessModel> guessList = args[0] ?? [];
      final String mode = args[1];
      return PageRouteBuilder(
        settings: const RouteSettings(name: RoutePaths.challengeGameByImage),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder:
            (_, _, _) => ChallengeGameByImage(guessList: guessList, mode: mode),
      );
    case RoutePaths.challengeGameByText:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final List<GuessModel> guessList = args[0] ?? [];
      final String mode = args[1];
      return PageRouteBuilder(
        settings: const RouteSettings(name: RoutePaths.challengeGameByText),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder:
            (_, _, _) => ChallengeGameByText(guessList: guessList, mode: mode),
      );
    case RoutePaths.battle:
      return MaterialPageRoute(
        settings: const RouteSettings(name: RoutePaths.battle),
        builder: (BuildContext context) {
          return const Battle();
        },
      );
    case RoutePaths.battleGame:
      return MaterialPageRoute(
        settings: const RouteSettings(name: RoutePaths.battleGame),
        builder: (BuildContext context) {
          final List<dynamic> args = setting.arguments as List<dynamic>;
          final List<BattleQuestionModel> questions = args[0] ?? [];
          final MiniProfileModel user = args[1];
          final MiniProfileModel bot = args[2];
          final BotDifficulty botDifficulty = args[3];
          return BattleGame(
            questions: questions,
            user: user,
            bot: bot,
            botDifficulty: botDifficulty,
          );
        },
      );
    case RoutePaths.battleChallengeGame:
      return MaterialPageRoute(
        settings: const RouteSettings(name: RoutePaths.battleChallengeGame),
        builder: (BuildContext context) {
          final List<dynamic> args = setting.arguments as List<dynamic>;
          final String roomId = args[0];
          final List<BattleQuestionModel> questions = args[1] ?? [];
          final MiniProfileModel host = args[2];
          final MiniProfileModel friend = args[3];
          final bool isHost = args[4];
          return BattleChallengeGame(
            roomId: roomId,
            questions: questions,
            host: host,
            friend: friend,
            isHost: isHost,
          );
        },
      );
    case RoutePaths.battleIntro:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final List<BattleQuestionModel> questions = args[0] ?? [];
      final MiniProfileModel user = args[1];
      final MiniProfileModel bot = args[2];
      final BotDifficulty botDifficulty = args[3];
      return AnimationRoute.scale(
        settings: setting,
        page: BattleIntro(
          questions: questions,
          user: user,
          bot: bot,
          botDifficulty: botDifficulty,
        ),
      );
    case RoutePaths.battleGameResult:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final String result = args[0];
      final MiniProfileModel user = args[1];
      final MiniProfileModel bot = args[2];
      return AnimationRoute.scale(
        settings: setting,
        page: BattleGameResult(result: result, user: user, bot: bot),
      );
    case RoutePaths.battleChallengeResult:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final String result = args[0];
      final MiniProfileModel user = args[1];
      final MiniProfileModel bot = args[2];
      final String? roomId = args[3];
      return AnimationRoute.scale(
        settings: setting,
        page: BattleChallengeResult(
          result: result,
          user: user,
          bot: bot,
          roomId: roomId,
        ),
      );
    case RoutePaths.leaderboard:
      return AnimationRoute.scale(settings: setting, page: const Leaderboard());
    case RoutePaths.battleChallenge:
      return AnimationRoute.scale(
        settings: setting,
        page: const BattleChallenge(),
      );
    case RoutePaths.battleChallengeIntro:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final String roomId = args[0];
      final MiniProfileModel host = args[1];
      final MiniProfileModel friend = args[2];
      final List<int> questions = List<int>.from(args[3]);
      final bool isHost = args[4];
      return AnimationRoute.scale(
        settings: setting,
        page: BattleChallengeIntro(
          roomId: roomId,
          host: host,
          friend: friend,
          questions: questions,
          isHost: isHost,
        ),
      );
    case RoutePaths.friends:
      return AnimationRoute.scale(settings: setting, page: const Friends());
    case RoutePaths.library:
      return AnimationRoute.scale(settings: setting, page: const Library());
    case RoutePaths.countryDetail:
      final Object? args = setting.arguments;
      final int index = (args as int? ?? int) as int;
      return AnimationRoute.scale(
        settings: setting,
        page: CountryDetail(index: index),
      );
    case RoutePaths.adventureVictory:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final String mode = args[0];
      final String levelId = args[1];
      final int life = args[2];
      final List<GuessModel> guessList = args[3];
      final bool isReplay = args[4];
      return PageRouteBuilder(
        settings: const RouteSettings(name: RoutePaths.adventureVictory),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder:
            (_, _, _) => AdventureVictory(
              mode: mode,
              levelId: levelId,
              life: life,
              guessList: guessList,
              isReplay: isReplay,
            ),
      );
    case RoutePaths.challengeVictory:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final String mode = args[0];
      final int life = args[1];
      final int currentIndex = args[2];
      final bool isReplay = args[3];
      return PageRouteBuilder(
        settings: const RouteSettings(name: RoutePaths.challengeVictory),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder:
            (_, _, _) => ChallengeVictory(
              mode: mode,
              life: life,
              currentIndex: currentIndex,
              isReplay: isReplay,
            ),
      );
    default:
      return PageRouteBuilder(
        pageBuilder:
            (_, Animation<double> a1, Animation<double> a2) =>
                const SplashScreen(),
      );
  }
}

class AnimationRoute {
  static PageRouteBuilder<T> scale<T>({
    required Widget page,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: child,
        );
      },
    );
  }
}
