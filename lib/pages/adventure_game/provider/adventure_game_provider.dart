import 'dart:async';
import 'dart:math';

import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/adventure_completed_model.dart';
import 'package:flaguiz/models/guess_model.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/vibration_service.dart';
import 'package:flaguiz/utils/asset_audios.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class AdventureGameProvider extends ChangeNotifier {
  AdventureGameProvider(
      {required BuildContext buildContext,
      PageController? pageController,
      required List<GuessModel> guessList,
      String mode = '',
      String levelId = ''}) {
    _pageController = pageController;
    _mode = mode;
    _levelId = levelId;
    _guessList = guessList;
    _guessList.shuffle();
    startTimerCount();
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
  }

  Timer? _timer;
  PageController? _pageController;
  bool _youLose = false;
  int _remainingLife = 3;
  int _correctAnswerIndex = 0;
  int _timerCount = CcConfig.GAME_TIMER_COUNT;
  List<int> _userWrongGuesses = [];
  String _mode = '';
  String _levelId = '';
  List<GuessModel> _guessList = [];

  List<GuessModel> get guessList => _guessList;
  bool get youLose => _youLose;
  int get remainingLife => _remainingLife;
  int get correctAnswerIndex => _correctAnswerIndex;
  int get timerCount => _timerCount;
  String get mode => _mode;
  String get levelId => _levelId;
  List<int> get userWrongGuesses => _userWrongGuesses;

  set setRemainingLife(int remainingLife) {
    _remainingLife = remainingLife;
    notifyListeners();
  }

  set setUserWrongGuesses(List<int> list) {
    _userWrongGuesses = list;
    notifyListeners();
  }

  set setCorrectAnswerIndex(int correctAnswerIndex) {
    _correctAnswerIndex = correctAnswerIndex;
  }

  void addUserWrongGuesses(int index) {
    _userWrongGuesses.add(index);
    notifyListeners();
  }

  startTimerCount() {
    _timerCount = CcConfig.GAME_TIMER_COUNT;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCount > 0) {
        if (_timerCount <= 4) {
        VibrationService.instance.heavy();
      }
        _timerCount--;
        notifyListeners();
      } else {
        decreaseLife();
        if (_remainingLife > 0) {
          _timerCount = CcConfig.GAME_TIMER_COUNT;
        } else {
          _youLose = true;
          _timer?.cancel();
          playLoseSound();
        }
      }
    });
  }

  goToNext(BuildContext context, String answerId, String guessId,
      List<AdventureCompletedModel> list) {
    if (_pageController != null) {
      if (_pageController!.hasClients) {
        _userWrongGuesses = [];
        _timerCount = CcConfig.GAME_TIMER_COUNT;
        final nextPage = _pageController!.page!.toInt() + 1;

        if (answerId == guessId) {
          if (nextPage < _guessList.length) {
            _pageController!.animateToPage(nextPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          } else {
            Navigator.of(context)
                .pushReplacementNamed(RoutePaths.adventureVictory, arguments: [
              _mode,
              _levelId,
              _remainingLife,
              _guessList,
              isReplay(list)
            ]);
          }
        }
      }
    }
  }

  bool isReplay(List<AdventureCompletedModel> list) {
    final int index = list.indexWhere((item) => item.levelId == _levelId);
    if (index != -1 && list[index].life != '0') {
      return true;
    }
    return false;
  }

  void hint(
      BuildContext context, List<AdventureCompletedModel> list, int coin) {
    if (coin >= 10) {
      if (_userWrongGuesses.length == 3) {
        _userWrongGuesses = [];
        final nextPage = _pageController!.page!.toInt() + 1;
        if (nextPage == guessList.length) {
          Navigator.of(context)
              .pushReplacementNamed(RoutePaths.adventureVictory, arguments: [
            _mode,
            _levelId,
            _remainingLife,
            _guessList,
            isReplay(list)
          ]);
        } else {
          _pageController!.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } else {
        final List<int> numbers = [0, 1, 2, 3];
        numbers.remove(_correctAnswerIndex);
        numbers.shuffle();
        final random = Random();

        for (var value in _userWrongGuesses) {
          numbers.remove(value);
        }

        int hintCountry = numbers[random.nextInt(numbers.length)];
        _userWrongGuesses.add(hintCountry);
        notifyListeners();
      }
    }
  }

  Future<void> playLoseSound() async {
    if (_youLose) {
      await AudioService.instance.startSoundTrack(AssetAudios.adventureLoseSound);
    }
  }

  void increaseLife() {
    if (_remainingLife < 3) {
      _remainingLife++;
    }
    notifyListeners();
  }

  void decreaseLife() {
    if (_remainingLife > 1) {
      _remainingLife--;
    } else {
      _youLose = true;
      _remainingLife = 0;
      _timer?.cancel();
      playLoseSound();
    }
    notifyListeners();
  }

  void playOn() {
    _remainingLife = _remainingLife + 1;
    startTimerCount();
    notifyListeners();
  }

  @override
  void dispose() {
    Utils.printLog('${runtimeType.toString()} Dispose $hashCode',
        important: true);
    _timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }
}
