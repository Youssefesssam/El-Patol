class ModelHiEvent {
  static const String collection = 'hiEvent';
  final String eventText;
  final DateTime timestamp;

  ModelHiEvent({required this.eventText, required this.timestamp});


  factory ModelHiEvent.fromJson(Map<String, dynamic> json) {
    return ModelHiEvent(
      eventText: json['eventText'],
      timestamp: json['timestamp'].toDate(),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      eventText:'eventText',
    };
  }
}
