import 'dart:math';

import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/utils/enum/question_type.dart';

class BattleQuestionService {
  List<BattleQuestionModel> generateBattleList(
    List<CountryModel> allCountries,
    int difficulty,
  ) {
    final config = difficultyConfigs[difficulty]!;

    final random = Random();

    final shuffled = List<CountryModel>.from(allCountries)..shuffle(random);

    final selected = shuffled.take(20).toList();

    final List<BattleQuestionModel> list = [];

    for (final country in selected) {
      list.add(_generateQuestionWithAnswer(allCountries, config, country));
    }

    return list;
  }

  BattleQuestionModel _generateQuestionWithAnswer(
    List<CountryModel> allCountries,
    DifficultyConfig config,
    CountryModel answer,
  ) {
    final type = _pickWeighted(config.weights);

    final options = _generateOptions(answer, allCountries);

    return BattleQuestionModel(
      answer: answer,
      options: options,
      type: type,
    );
  }

  QuestionType _pickWeighted(Map<QuestionType, double> weights) {
    final random = Random();
    final total = weights.values.reduce((a, b) => a + b);
    double roll = random.nextDouble() * total;

    for (var entry in weights.entries) {
      if (roll < entry.value) return entry.key;
      roll -= entry.value;
    }

    return weights.keys.first;
  }

  List<CountryModel> _generateOptions(
    CountryModel answer,
    List<CountryModel> allCountries,
  ) {
    final random = Random();
    final List<CountryModel> options = [answer];
    List<String> similarFlags = answer.similarFlags ?? [];

    // 1. Add similar flags first
    final similar =
        allCountries.where((c) => similarFlags.contains(c.id)).toList();

    similar.shuffle();

    for (var c in similar) {
      if (options.length >= 4) break;
      options.add(c);
    }

    while (options.length < 4) {
      final rand = allCountries[random.nextInt(allCountries.length)];
      if (!options.contains(rand)) {
        options.add(rand);
      }
    }

    options.shuffle();
    return options;
  }

  final difficultyConfigs = {
    1: DifficultyConfig({
      QuestionType.flag: 1.0,
    }),
    2: DifficultyConfig({
      QuestionType.flag: 0.7,
      QuestionType.country: 0.3,
    }),
    3: DifficultyConfig({
      QuestionType.flag: 0.5,
      QuestionType.country: 0.3,
      QuestionType.map: 0.2,
    }),
    4: DifficultyConfig({
      QuestionType.flag: 0.4,
      QuestionType.country: 0.25,
      QuestionType.map: 0.2,
      QuestionType.capital: 0.15,
    }),
    5: DifficultyConfig({
      QuestionType.flag: 0.25,
      QuestionType.country: 0.25,
      QuestionType.map: 0.25,
      QuestionType.capital: 0.25,
    }),
  };
}

class DifficultyConfig {
  final Map<QuestionType, double> weights;

  DifficultyConfig(this.weights);
}