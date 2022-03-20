import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker_app/repository/mysql_connection_repository.dart';

import '../model/session.dart';

final sessionRepository = Provider.autoDispose<SessionRepository>(
    (ref) => SessionRepositoryImpl(ref.read));

//インターフェース
abstract class SessionRepository {
  Future<List<Session>> getSessions(String sessionKey);
  Future<void> addSession(Session session);
}

//実装クラス
class SessionRepositoryImpl implements SessionRepository {
  final Reader _read;
  SessionRepositoryImpl(this._read);

  //取得
  Future<List<Session>> getSessions(String sessionKey) async {
    var conn = await _read(mysqlConnetionRepository).connectMySql();

    var sql =
        "select Id,SessionKey,EmployeeId from ApplicationSessions where SessionKey = ?";
    var sessions = await conn.query(sql, [sessionKey]);
    conn.close();

    return sessions.map((e) => Session.fromMap(e.fields)).toList();
  }

  Future<void> addSession(Session session) async {
    var conn = await _read(mysqlConnetionRepository).connectMySql();
    var sql =
        "insert into ApplicationSessions (sessionKey, employeeId) values (?, ?)";
    await conn.query(sql, [session.sessionKey, session.employeeId]);
    conn.close();
  }
}
