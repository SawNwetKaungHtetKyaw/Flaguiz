import 'package:flaguiz/bot/bot_difficulty.dart';
import 'package:flaguiz/bot/bot_model.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/models/guess_model.dart';
import 'package:flaguiz/pages/about/about.dart';
import 'package:flaguiz/pages/adventure/adventure.dart';
import 'package:flaguiz/pages/adventure/adventure_level.dart';
import 'package:flaguiz/pages/battle/battle.dart';
import 'package:flaguiz/pages/battle_challenge/battle_challenge.dart';
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
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return const SplashScreen();
      });
    case RoutePaths.loading:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.loading),
          builder: (BuildContext context) {
            return const Loading();
          });
    case RoutePaths.home:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.home),
          builder: (BuildContext context) {
            return const Home();
          });
    case RoutePaths.profile:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.profile),
          builder: (BuildContext context) {
            return const Profile();
          });
    case RoutePaths.about:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.about),
          builder: (BuildContext context) {
            return const About();
          });
    case RoutePaths.privacyPolicies:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.privacyPolicies),
          builder: (BuildContext context) {
            return const PrivacyPolicies();
          });
    case RoutePaths.termsConditions:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.termsConditions),
          builder: (BuildContext context) {
            return const TermsConditions();
          });
    case RoutePaths.shop:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.shop),
          builder: (BuildContext context) {
            return const Shop();
          });
    case RoutePaths.shopDetail:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.shopDetail),
          builder: (BuildContext context) {
            final Object? args = setting.arguments;
            final String category = (args as String? ?? String) as String;
            return ShopDetail(category: category);
          });
    case RoutePaths.adventure:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.adventure),
          builder: (BuildContext context) {
            return const Adventure();
          });
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
        pageBuilder: (_, _, _) => AdventureGameByImage(
            guessList: guessList, mode: mode, levelId: levelId),
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
        pageBuilder: (_,_, _) => AdventureGameByText(
            guessList: guessList, mode: mode, levelId: levelId),
      );
    case RoutePaths.challenge:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.challenge),
          builder: (BuildContext context) {
            return const Challenge();
          });
    case RoutePaths.challengeGameByImage:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final List<GuessModel> guessList = args[0] ?? [];
      final String mode = args[1];
      return PageRouteBuilder(
        settings: const RouteSettings(name: RoutePaths.challengeGameByImage),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, _, _) =>
            ChallengeGameByImage(guessList: guessList, mode: mode),
      );
    case RoutePaths.challengeGameByText:
      final List<dynamic> args = setting.arguments as List<dynamic>;
      final List<GuessModel> guessList = args[0] ?? [];
      final String mode = args[1];
      return PageRouteBuilder(
        settings: const RouteSettings(name: RoutePaths.challengeGameByText),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, _, _) =>
            ChallengeGameByText(guessList: guessList, mode: mode),
      );
    case RoutePaths.battle:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.battle),
          builder: (BuildContext context) {
            return const Battle();
          });
    case RoutePaths.battleGame:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.battleGame),
          builder: (BuildContext context) {
            final List<dynamic> args = setting.arguments as List<dynamic>;
            final List<BattleQuestionModel> questions = args[0] ?? [];
            final BotModel user = args[1];
            final BotModel bot = args[2];
            final BotDifficulty botDifficulty = args[3];
            return BattleGame(
              questions: questions,
              user: user,
              bot: bot,
              botDifficulty: botDifficulty,
            );
          });
    case RoutePaths.battleIntro:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.battleIntro),
          builder: (BuildContext context) {
            final List<dynamic> args = setting.arguments as List<dynamic>;
            final List<BattleQuestionModel> questions = args[0] ?? [];
            final BotModel user = args[1];
            final BotModel bot = args[2];
            final BotDifficulty botDifficulty = args[3];
            return BattleIntro(
              questions: questions,
              user: user,
              bot: bot,
              botDifficulty: botDifficulty,
            );
          });
    case RoutePaths.battleGameResult:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.battleGameResult),
          builder: (BuildContext context) {
            final List<dynamic> args = setting.arguments as List<dynamic>;
            final String result = args[0];
            final BotModel user = args[1];
            final BotModel bot = args[2];
            return BattleGameResult(result: result, user: user, bot: bot);
          });
    case RoutePaths.leaderboard:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.leaderboard),
          builder: (BuildContext context) {
            return const Leaderboard();
          });
    case RoutePaths.battleChallenge:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.battleChallenge),
          builder: (BuildContext context) {
            return const BattleChallenge();
          });
    case RoutePaths.friends:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.friends),
          builder: (BuildContext context) {
            return const Friends();
          });
    case RoutePaths.library:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.library),
          builder: (BuildContext context) {
            return const Library();
          });
    case RoutePaths.countryDetail:
      return MaterialPageRoute(
          settings: const RouteSettings(name: RoutePaths.countryDetail),
          builder: (BuildContext context) {
            final Object? args = setting.arguments;
            final int index = (args as int? ?? int) as int;
            return CountryDetail(index: index);
          });
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
        pageBuilder: (_, _, _) => AdventureVictory(
            mode: mode,
            levelId: levelId,
            life: life,
            guessList: guessList,
            isReplay: isReplay),
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
        pageBuilder: (_, _, _) => ChallengeVictory(
            mode: mode,
            life: life,
            currentIndex: currentIndex,
            isReplay: isReplay),
      );
    default:
      return PageRouteBuilder(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              const SplashScreen());
  }
}
