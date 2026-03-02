import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/adventure_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/guess_model.dart';
import 'package:flaguiz/service/cached_image_manager_service.dart';
import 'package:flutter/material.dart';

class Utils {
  static void printLog(Object? object, {bool important = false}) {
    if (CcConfig.showLog & important) {
      // red
      print('\u001b[31m $object \u001b[0m');
    } else {
      // green
      print('\u001b[32m $object \u001b[0m');
    }
  }

  static void debugLog(String string) {
    print('\u001b[35m ====>$string \u001b[0m');
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
      List<CountryModel> countries) {
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
        CountryModel otherSimilarCountry =
            countries.firstWhere((country) => country.id == c);
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
      AdventureModel adventureModel, List<CountryModel> countries) {
    List<GuessModel> gameGuessList = [];
    adventureModel.guessList!.shuffle();
    for (var guess in adventureModel.guessList!) {
      GuessModel gameGuess = GuessModel();

      /// Prepare Correct Country
      CountryModel correctCountry =
          countries.firstWhere((country) => country.id == guess);
      gameGuess.answer = correctCountry;

      /// Prepare Guess Countries
      gameGuess.countryList = [];
      gameGuess.countryList!.add(correctCountry);

      final random = Random();

      final shuffled = List.of(correctCountry.similarFlags!)..shuffle(random);

      final randomThreeCountries = shuffled.take(3).toList();

      for (var c in randomThreeCountries) {
        CountryModel otherSimilarCountry =
            countries.firstWhere((country) => country.id == c);
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
      return CachedNetworkImageProvider(path,
          cacheManager: CachedImageManagerService());
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
}
