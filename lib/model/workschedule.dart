import 'package:intl/intl.dart';

//TODO:定数の使用を検討（現在は未使用）
const String Id = "Id";
const String StartTime = "StartTime";
const String EndTime = "EndTime";
const String RestTime = "RestTime";

class WorkSchedule {
  final int id;
  final int year;
  final int month;
  final int day;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime restTime;

  WorkSchedule(
      {required this.id,
      required this.year,
      required this.month,
      required this.day,
      required this.startTime,
      required this.endTime,
      required this.restTime});

  //休憩時間を引いて勤務時間を算出
  int get minMinute => 480;

  int get workMinute {
    return endTime
        .add(Duration(hours: -restTime.hour, minutes: -restTime.minute))
        .difference(startTime)
        .inMinutes;
  }

  //残業時間を算出
  int get overHour =>
      (workMinute > minMinute ? workMinute - minMinute : 0) ~/ 60;
  int get overMinutes =>
      (workMinute > minMinute ? workMinute - minMinute : 0) % 60;

  String get overTimeStr =>
      "${(overHour <= 0 && overMinutes <= 0) ? "" : "${overHour.toString().padLeft(2, "0")}:${overMinutes.toString().padLeft(2, "0")}"}";

  /* @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkSchedule &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          done == other.done &&
          timestamp == other.timestamp &&
          id == other.id);*/

  //CopyWithの動作確認用
  @override
  int get hashCode =>
      id.hashCode ^ startTime.hashCode ^ endTime.hashCode ^ restTime.hashCode;

  @override
  String toString() {
    return 'WorkSchedule{' +
        ' Id: $id,' +
        ' StartTime: $startTime,' +
        ' EndTime: $endTime,' +
        ' RestTime: $restTime,' +
        '}';
  }

  //
  WorkSchedule copyWith({
    int? id,
    int? year,
    int? month,
    int? day,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? restTime,
  }) {
    return WorkSchedule(
        id: id ?? this.id,
        year: year ?? this.year,
        month: month ?? this.month,
        day: day ?? this.day,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        restTime: restTime ?? this.restTime);
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': this.id,
      'StartTime': this.startTime,
      'EndTime': this.endTime,
      'RestTime': this.restTime,
      //'endTime': this.endTime.toIso8601String(),
    };
  }

  factory WorkSchedule.fromMap(Map<String, dynamic> map) {
    return WorkSchedule(
        id: map['Id'] as int,
        year: map['Year'] as int,
        month: map['Month'] as int,
        day: map['Day'] as int,
        startTime: DateFormat.Hms().parseStrict(map["StartTime"]),
        endTime: DateFormat.Hms().parseStrict(map["EndTime"]),
        restTime: DateFormat.Hms().parseStrict(map["RestTime"]));
  }
}
