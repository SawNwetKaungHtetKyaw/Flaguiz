import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/utils/enum/question_type.dart';

class BattleQuestionModel {
  final CountryModel? answer;
  final List<CountryModel>? options;
  final QuestionType? type;

  BattleQuestionModel({this.answer, this.options, this.type});

  factory BattleQuestionModel.fromMap(Map<String, dynamic> map) {
    return BattleQuestionModel(
      answer: CountryModel.fromJson(map['answer']),

      options: List<CountryModel>.from(
        (map['options'] ?? []).map((e) => CountryModel.fromJson(e)),
      ),

      type: QuestionType.values.firstWhere((e) => e.name == map['type']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer?.toJson(),
      'options':
          options?.map((e) => e.toJson()).toList(),
      'type': type?.name,
    };
  }

  List<Map<String, dynamic>?> toMapList(List<BattleQuestionModel>? list) {
    final List<Map<String, dynamic>?> dynamicList = <Map<String, dynamic>?>[];
    if (list != null) {
      for (dynamic data in list) {
        if (data != null) {
          dynamicList.add(toMap());
        }
      }
    }
    return dynamicList;
  }
}
