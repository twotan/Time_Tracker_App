import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker_app/model/progressmessage.dart';
import 'package:time_tracker_app/model/workscheduleprogress.dart';
import 'package:time_tracker_app/repository/mysql_connection_repository.dart';

final workScheduleProgressRepository =
    Provider.autoDispose<WorkScheduleProgressRepository>(
        (ref) => WorkScheduleProgressRepositoryImpl(ref.read));

//インターフェース
abstract class WorkScheduleProgressRepository {
  Future<List<WorkScheduleProgress>> getWorkScheduleProgressList(
      {int? year = null, int? month = null, int? employeeId = null});
  Future<void> updateWorkScheduleProgress(WorkScheduleProgress progress,String? message);
}

//SharedPreferences用
//const _listKey = 'workScheduleListKey';

//実装クラス
class WorkScheduleProgressRepositoryImpl
    implements WorkScheduleProgressRepository {
  final Reader _read;
  WorkScheduleProgressRepositoryImpl(this._read);

  //取得
  @override
  Future<List<WorkScheduleProgress>> getWorkScheduleProgressList(
      {int? year = null, int? month = null, int? employeeId = null}) async {
    var conn = await _read(mysqlConnetionRepository).connectMySql();
    year = year ?? DateTime.now().year;
    month = month ?? 1;
    employeeId = employeeId ?? 673;

    var schedules = await conn.query(
        "select Id,EmployeeId,Year,Month,Status,WorkDate" +
            " from workscheduleprogress where Year = ? and Month = ? and EmployeeId = ?",
        [year, month, employeeId]);
    conn.close();

    return schedules
        .map((e) => WorkScheduleProgress.fromMap(e.fields))
        .toList();
  }

  @override
  Future<void> updateWorkScheduleProgress(WorkScheduleProgress progress,String? message) async {
    var conn = await _read(mysqlConnetionRepository).connectMySql();

    var sql =
        "Update workscheduleprogress Set Status = ?,Modified = ? where Id = ?";

    var mssageSql =
        "insert into ProgressMessages (Message, ProgressId,TimeStamp) values (?,?,?)";

    //TODO:Modifiedの更新をUTCにすべきか調査
    var now = DateTime.parse(DateTime.now().toUtc().toIso8601String());
    await conn.query(sql, [
      progress.status,
      now,
      progress.id
    ]);

    if(message != null && message.isNotEmpty){
    await conn.query(mssageSql, [message, progress.id,now]);
    }

/*    conn.transaction(() async => {
      await conn.query(sql, [
      progress.status,
      now,
      progress.id
      ]),
      if(message != null){
          await conn.query(mssageSql, [message, progress.id,now])
      }
    });*/

    conn.close();
  }
}
