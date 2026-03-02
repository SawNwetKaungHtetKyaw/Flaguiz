class AdventureModel {
  String? level;
  List<String>? guessList;

  AdventureModel({this.level, this.guessList});

  factory AdventureModel.fromJson(Map<String, dynamic> json) {
    return AdventureModel(
      level: json['level'] as String,
      guessList:
          (json['guess_list'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"level": level, "guess_list": guessList};
  }
}
