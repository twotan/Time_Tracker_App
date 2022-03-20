import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';
import 'package:time_tracker_app/constants.dart';

final mysqlConnetionRepository = Provider.autoDispose<MysqlConnetionRepository>(
    (ref) => MysqlConnetionRepositoryImpl());

abstract class MysqlConnetionRepository {
  Future<MySqlConnection> connectMySql();
}

class MysqlConnetionRepositoryImpl implements MysqlConnetionRepository {
  final _mysqlSettings = ConnectionSettings(
      host: MySqlSettings.host,
      port: MySqlSettings.port,
      user: MySqlSettings.user,
      password: MySqlSettings.password,
      db: MySqlSettings.db);

  Future<MySqlConnection> connectMySql() async {
    return await MySqlConnection.connect(_mysqlSettings);
  }
}
