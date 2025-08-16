class ModelSweetTalk {
  static const String collection = 'sweetTalk'; // اسم الكولكشن في الفايرستور
  final String talk;
  final DateTime timestamp;

  ModelSweetTalk({required this.talk, required this.timestamp});


  factory ModelSweetTalk.fromJson(Map<String, dynamic> json) {
    return ModelSweetTalk(
      talk: json['talk'],
      timestamp: json['timestamp'].toDate(),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      talk:'talk',

    };
  }
}
