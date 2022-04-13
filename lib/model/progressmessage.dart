class ProgressMessage {
  final int id;
  final String message;
  final int progressId;
  final DateTime timeStamp;

  ProgressMessage(
      {required this.id, required this.message, required this.progressId, required this.timeStamp});

  ProgressMessage copyWith({int? id, String? message, int? progressId,DateTime? timeStamp}) {
    return ProgressMessage(
        id: id ?? this.id,
        message: message ?? this.message,
        progressId: progressId ?? this.progressId,
        timeStamp: timeStamp?? this.timeStamp);
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': this.id,
      'Message': this.message,
      'ProgressId': this.progressId,
      'TimeStamp': this.timeStamp,
    };
  }

  factory ProgressMessage.fromMap(Map<String, dynamic> map) {
    return ProgressMessage(
        id: map['Id'] as int,
        message: map['Message'].toString(),
        progressId: map['ProgressId'] as int,
        timeStamp: map['TimeStamp'] as DateTime);
  }
}
