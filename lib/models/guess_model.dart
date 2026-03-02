import 'package:flaguiz/models/country_model.dart';

class GuessModel {
  CountryModel? answer;
  List<CountryModel>? countryList;

  GuessModel({this.answer, this.countryList});

  factory GuessModel.fromJson(Map<String, dynamic> json) {
    return GuessModel(
      answer: json['answer'] != null
          ? CountryModel.fromJson(Map<String, dynamic>.from(json['answer']))
          : null,
      countryList: json['country_list'] != null
          ? List<CountryModel>.from(
              (json['country_list'] as List)
                  .map((c) => CountryModel.fromJson(
                        Map<String, dynamic>.from(c),
                      )),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer?.toJson(),
      'country_list': countryList?.map((c) => c.toJson()).toList(),
    };
  }
}
