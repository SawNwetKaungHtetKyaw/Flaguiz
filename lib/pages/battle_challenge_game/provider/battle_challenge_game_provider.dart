import 'dart:async';

import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/models/battle_room_model.dart';
import 'package:flaguiz/repositories/battle_repository.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/battle_firestore_service.dart';
import 'package:flaguiz/service/vibration_service.dart';
import 'package:flutter/material.dart';

class BattleChallengeGameProvider extends ChangeNotifier {
  BattleChallengeGameProvider({
    required BuildContext buildContext,
    PageController? pageController,
    required String roomId,
    required bool isHost,
    required List<BattleQuestionModel> questionList,
  }) {
    _context = buildContext;
    _controller = pageController;
    _questionList = questionList;
    _isHost = isHost;
    _listenRoom(roomId);
    startTimerCount();
  }

  // =========================
  // CONTROLLERS
  // =========================
  BuildContext? _context;
  PageController? _controller;
  late List<BattleQuestionModel> _questionList;

  BattleRoomModel? room;
  StreamSubscription? _subscription;
  Timer? _timer;

  // =========================
  // STATE
  // =========================
  int _currentIndex = 0;
  int _timerCount = CcConfig.GAME_TIMER_COUNT;
  bool _gameEnded = false;
  String _battleResult = '';
  bool _isHost = false;

  String? _playerAnswerId;
  bool _playerAnswered = false;
  int _trackGuess = 0;

  // =========================
  // GETTERS
  // =========================
  int get currentIndex => _currentIndex;
  int get timerCount => _timerCount;
  bool get isGameEnded => _gameEnded;
  String get battleResult => _battleResult;
  int get trackGuess => _trackGuess;
  String? get playerAnswerId => _playerAnswerId;

  BattleQuestionModel get currentQuestion => _questionList[_currentIndex];

  // =========================
  // FIRESTORE LISTENER
  // =========================
  void _listenRoom(String roomId) {
    _subscription?.cancel();

    _subscription = BattleRepository().listenBattleRoom(roomId).listen((
      battleRoom,
    ) {
      room = battleRoom;

      if (room != null) {
        _syncGameFromRoom();
      }

      notifyListeners();
    });
  }

  // =========================
  // SYNC LOGIC (IMPORTANT)
  // =========================
  void _syncGameFromRoom() {
    if (room == null) return;

    final host = room!.hostProgress["$_currentIndex"] ?? 0;
    final friend = room!.friendProgress["$_currentIndex"] ?? 0;

    // Wait until both answered
    if (host == 0 || friend == 0) return;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_gameEnded) return;

      // Both correct
      if (host == 1 && friend == 1) {
        _nextQuestion();
        return;
      }

      // Both wrong
      if (host == -1 && friend == -1) {
        _endGame(CcConstants.BATTLE_DRAW);
        return;
      }

      // Host correct, Friend wrong
      if (host == 1 && friend == -1) {
        _endGame(_isHost ? CcConstants.BATTLE_WIN : CcConstants.BATTLE_LOSE);
        return;
      }

      // Host wrong, Friend correct
      if (host == -1 && friend == 1) {
        _endGame(_isHost ? CcConstants.BATTLE_LOSE : CcConstants.BATTLE_WIN);
        return;
      }
    });
  }

  // =========================
  // PLAYER ANSWER
  // =========================
  void playerAnswer(String answerId) async {
    if (_gameEnded || _playerAnswered || room == null) return;

    _playerAnswerId = answerId;
    _playerAnswered = true;

    final correctId = currentQuestion.answer?.id;

    if (_playerAnswerId == correctId) {
      _trackGuess = 1;
      AudioService.instance.playSound('correct');
    } else {
      _trackGuess = -1;
      VibrationService.instance.medium();
    }

    notifyListeners();

    // UPDATE FIRESTORE

    final path =
        _isHost
            ? 'host_progress.$_currentIndex'
            : 'friend_progress.$_currentIndex';

    await BattleFirestoreService().battleRooms.doc(room!.roomId).update({
      path: _trackGuess,
    });
  }

  // =========================
  // NEXT QUESTION
  // =========================
  void _nextQuestion() {
    if (_gameEnded) return;

    _currentIndex++;

    if (_currentIndex >= _questionList.length) {
      _endGame(CcConstants.BATTLE_DRAW);
      return;
    }

    _playerAnswered = false;
    _playerAnswerId = null;
    _trackGuess = 0;

    _timerCount = CcConfig.GAME_TIMER_COUNT;

    _controller?.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    notifyListeners();
  }

  // =========================
  // TIMER
  // =========================
  void startTimerCount() {
    _timer?.cancel();

    _timerCount = CcConfig.GAME_TIMER_COUNT;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameEnded) return;

      if (_timerCount > 0) {
        if (_timerCount <= 6) {
          VibrationService.instance.heavy();
        }
        _timerCount--;
        notifyListeners();
      } else {
        if (_trackGuess == 1) {
          _endGame(CcConstants.BATTLE_WIN);
        } else {
          _endGame(CcConstants.BATTLE_LOSE);
        }
      }
    });
  }

  // =========================
  // END GAME
  // =========================
  void _endGame(String result) {
    if (_gameEnded) return;

    _timer?.cancel();

    _gameEnded = true;
    _battleResult = result;

    notifyListeners();

    if (_context != null) {
      Navigator.pushReplacementNamed(
        _context!,
        RoutePaths.battleChallengeResult,
        arguments: [
          result,
          _isHost ? room!.host : room!.friend,
          _isHost ? room!.friend : room!.host,
        ],
      );
    }
  }

  // =========================
  // DISPOSE
  // =========================
  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
