class ModelWeek{
  static const String collection = 'Week';
  late String name;
  ModelWeek({
    required this.name,

  });
  ModelWeek.fromJson(Map<String, dynamic> json) {
    name =json["name"];
  }

  Map<String, dynamic> toJson() {
    return {
      'name' :name,

    };
  }
}