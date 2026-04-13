import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/utils/enum/question_type.dart';

class BattleQuestionModel {
  final CountryModel answer;
  final List<CountryModel> options;
  final QuestionType type;

  BattleQuestionModel({
    required this.answer,
    required this.options,
    required this.type,
  });
}