import 'dart:math';

import 'package:flaguiz/bot/bot_difficulty.dart';
import 'package:flaguiz/models/battle_question_model.dart';

class BotBrain {
  final BotDifficulty difficulty;
  final Random _random = Random();

  BotBrain(this.difficulty);

  /// First 3 questions always correct
  bool shouldAnswerCorrect(int questionIndex) {
    if (questionIndex < 3) return true;

    double chance = _correctChance();
    print("========>$chance");
    return _random.nextDouble() < chance;
  }

  double _correctChance() {
    switch (difficulty) {
      case BotDifficulty.newbie:
        return 0.6;
      case BotDifficulty.easy:
        return 0.7;
      case BotDifficulty.medium:
        return 0.8;
      case BotDifficulty.hard:
        return 0.85;
      case BotDifficulty.pro:
        return 0.9;
    }
  }

  /// Thinking time (human-like delay)
  Duration thinkingTime() {
    int ms = 800 + _random.nextInt(4200); // 800ms → 5000ms
    return  Duration(milliseconds: ms);
  }

  /// Pick answer
  String pickAnswer(
    BattleQuestionModel question,
    int questionIndex,
  ) {
    bool correct = shouldAnswerCorrect(questionIndex);

    if (correct) {
      return question.answer?.id ?? '0';
    } else {
      final wrongOptions = question.options!
          .where((e) => e.id != question.answer?.id)
          .toList();

      return wrongOptions[_random.nextInt(wrongOptions.length)].id ?? "0";
    }
  }
}