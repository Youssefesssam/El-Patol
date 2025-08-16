class HiEvent{
  static const String collection='sweetTalk';
  late String talk ;
  //late String image;
  HiEvent({required this.talk});

  HiEvent.fromJson(Map<String, dynamic> json) {
    talk =json["Talk"];
  }
  Map<String, dynamic> toJson(){
    return{
      talk:'talk',

    };
  }

}