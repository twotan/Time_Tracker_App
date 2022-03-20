import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker_app/model/workschedule.dart';
import 'package:time_tracker_app/repository/mysql_connection_repository.dart';

final workScheduleRepository = Provider.autoDispose<WorkScheduleRepository>(
    (ref) => WorkScheduleRepositoryImpl(ref.read));

//インターフェース
abstract class WorkScheduleRepository {
  Future<List<WorkSchedule>> getWorkScheduleList(
      {int? year = null, int? month = null, int? employeeId = null});
  Future<void> updateWorkSchedule(WorkSchedule schedule);
  Future<void> saveTodoList(List<WorkSchedule> todoList);
  Future<List<int>> getWorkScheduleYearList({int? employeeId = null});
}

//SharedPreferences用
//const _listKey = 'workScheduleListKey';

//実装クラス
class WorkScheduleRepositoryImpl implements WorkScheduleRepository {
  final Reader _read;
  WorkScheduleRepositoryImpl(this._read);

  //取得
  Future<List<WorkSchedule>> getWorkScheduleList(
      {int? year = null, int? month = null, int? employeeId = null}) async {
    var conn = await _read(mysqlConnetionRepository).connectMySql();
    year = year ?? DateTime.now().year;
    month = month ?? 1;
    employeeId = employeeId ?? 673;

    var schedules = await conn.query(
        "select Id, EmployeeId, Year, Month, Day, TimeStamp, time_format(StartTime, '%H:%i:%s') as StartTime,time_format(EndTime, '%H:%i:%s') as EndTime" +
            ",time_format(RestTime, '%H:%i:%s') as RestTime, IsLeave, IsPaidLeave, Reason from workschedules where Year = ? and Month = ? and EmployeeId = ?",
        [year, month, employeeId]);
    conn.close();

    return schedules.map((e) => WorkSchedule.fromMap(e.fields)).toList();
  }

  Future<void> updateWorkSchedule(WorkSchedule schedule) async {
    var conn = await _read(mysqlConnetionRepository).connectMySql();
    var now = DateTime.now();
    var dateFormat = new DateFormat('HH:mm', "ja_JP");
    var sql =
        "Update workschedules Set StartTime = ?,EndTime = ?,RestTime = ?,Modified = ? where Id = ?";

    //TODO:Modifiedの更新をUTCにすべきか調査
    await conn.query(sql, [
      dateFormat.format(schedule.startTime),
      dateFormat.format(schedule.endTime),
      dateFormat.format(schedule.restTime),
      DateTime.parse(now.toUtc().toIso8601String()),
      schedule.id
    ]);
    conn.close();
  }

  //保存
  Future<void> saveTodoList(List<WorkSchedule> todoList) async {
    var conn = await _read(mysqlConnetionRepository).connectMySql();
    var now = DateTime.now();
    var sql = "";
    await conn.query(sql);
    conn.close();

    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    //TODO:外部DBへのアクセスに変更
/*    await prefs.setString(_todoListKey,
        jsonEncode(todoList.map((todo) => todo.toMap()).toList()));*/
  }

  Future<List<int>> getWorkScheduleYearList({int? employeeId = null}) async {
    employeeId = employeeId ?? 673;

    var conn = await _read(mysqlConnetionRepository).connectMySql();
    var sql = "select distinct Year from workschedules where EmployeeId = ?";
    var years = await conn.query(sql, [employeeId]);
    conn.close();
    List<int> list = [];
    for (var row in years) {
      list.add(row["Year"] as int);
    }

    return list;
  }
}
