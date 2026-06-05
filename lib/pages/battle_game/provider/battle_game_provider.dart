import 'dart:async';

import 'package:flaguiz/bot/bot_brain.dart';
import 'package:flaguiz/bot/bot_difficulty.dart';
import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/service/ads_service.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/vibration_service.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class BattleGameProvider extends ChangeNotifier {
  BattleGameProvider({
    required BuildContext buildContext,
    PageController? pageController,
    required BotDifficulty botDifficulty,
    required List<BattleQuestionModel> questionList,
  }) {
    Utils.printLog('${runtimeType.toString()} Init $hashCode');
    _controller = pageController;
    _questionList = questionList;
    _botBrain = BotBrain(botDifficulty);
    startBotThinking();
    startTimerCount();
  }

  /// =========================
  /// Controllers & Data
  /// =========================
  late PageController? _controller;
  late List<BattleQuestionModel> _questionList;
  late BotBrain _botBrain;
  Timer? _timer;

  int _currentIndex = 0;
  int _timerCount = CcConfig.GAME_TIMER_COUNT;

  /// =========================
  /// Player & Bot State
  /// =========================
  String? _playerAnswerId;
  String? _botAnswer;

  bool _playerAnswered = false;
  bool _botAnswered = false;

  bool _gameEnded = false;
  String _battleResult = '';

  int _trackPlayerGuess = 0; // 1 correct, -1 wrong, 0 idle
  int _trackBotGuess = 0; // 1 correct, -1 wrong, 0 idle

  /// =========================
  /// Getters
  /// =========================
  int get currentIndex => _currentIndex;
  int get trackPlayerGuess => _trackPlayerGuess;
  int get trackBotGuess => _trackBotGuess;
  String? get playerAnswerId => _playerAnswerId;
  bool get isGameEnded => _gameEnded;
  String get battleResult => _battleResult;
  int get timerCount => _timerCount;

  BattleQuestionModel get currentQuestion => _questionList[_currentIndex];

  /// =========================
  /// Start Timer
  /// =========================

  void startTimerCount() {
    _timerCount = CcConfig.GAME_TIMER_COUNT;
    if (_gameEnded) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCount > 0) {
        if (_timerCount <= 6) {
          VibrationService.instance.heavy();
        }
        _timerCount--;
        notifyListeners();
      } else {
        _timer?.cancel();
        if (_gameEnded) return;
        _endGame(CcConstants.BATTLE_LOSE);
      }
    });
  }

  /// =========================
  /// Start Bot Thinking
  /// =========================
  void startBotThinking() async {
    if (_gameEnded) return;

    _botAnswered = false;
    _trackBotGuess = 0;
    notifyListeners();

    final question = currentQuestion;

    await Future.delayed(_botBrain.thinkingTime());

    if (_gameEnded) return;

    final answer = _botBrain.pickAnswer(question, _currentIndex);

    _botAnswer = answer;
    _botAnswered = true;

    final correctId = question.answer?.id;
    _trackBotGuess = (_botAnswer == correctId) ? 1 : -1;

    notifyListeners();

    _checkAndProceed();
  }

  /// =========================
  /// Player Answer
  /// =========================
  void playerAnswer(String guessId) {
    if (_gameEnded || _playerAnswered) return;

    _playerAnswerId = guessId;
    _playerAnswered = true;

    final correctId = currentQuestion.answer?.id;
    if (_playerAnswerId == correctId) {
      _trackPlayerGuess = 1;
      AudioService.instance.playSound('correct');
    } else {
      _trackPlayerGuess = -1;
      VibrationService.instance.medium();
    }

    notifyListeners();

    _checkAndProceed();
  }

  /// =========================
  /// Core Battle Logic
  /// =========================
  void _checkAndProceed() async {
    if (!_playerAnswered || !_botAnswered) return;

    final correctId = currentQuestion.answer?.id;

    bool playerCorrect = _playerAnswerId == correctId;
    bool botCorrect = _botAnswer == correctId;

    /// Small delay for UI feedback
    await Future.delayed(const Duration(milliseconds: 400));

    /// Win / Lose / Draw logic
    if (!playerCorrect && !botCorrect) {
      _endGame(CcConstants.BATTLE_DRAW);
      return;
    } else if (!playerCorrect) {
      _endGame(CcConstants.BATTLE_LOSE);
      return;
    } else if (!botCorrect) {
      _endGame(CcConstants.BATTLE_WIN);
      return;
    }

    /// ✅ Both correct → next question
    _currentIndex++;

    if (_currentIndex >= _questionList.length) {
      _endGame(CcConstants.BATTLE_DRAW);
      return;
    }

    /// Reset state
    _playerAnswered = false;
    _botAnswered = false;
    _playerAnswerId = null;
    _botAnswer = null;
    _trackPlayerGuess = 0;
    _trackBotGuess = 0;

    _timerCount = CcConfig.GAME_TIMER_COUNT;

    /// Move Page
    _controller!.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    notifyListeners();

    /// Start next bot thinking
    startBotThinking();
  }

  /// =========================
  /// End Game
  /// =========================
  void _endGame(String result) {
    _timer?.cancel();
    if (result == CcConstants.BATTLE_WIN) {
      _gameEnded = true;
      _battleResult = result;
      notifyListeners();
    } else {
      AdsService.instance.showInterstitialAds(
        CcAdsKey.interstitialBattleAds,
        onComplete: () {
          _gameEnded = true;
          _battleResult = result;
          notifyListeners();
        },
      );
    }
  }

  @override
  void dispose() {
    Utils.printLog(
      '${runtimeType.toString()} Dispose $hashCode',
      important: true,
    );
    _timer?.cancel();
    super.dispose();
  }
}
