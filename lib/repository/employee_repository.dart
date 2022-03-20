import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker_app/model/employee.dart';
import 'package:time_tracker_app/repository/mysql_connection_repository.dart';

final employeeRepository = Provider.autoDispose<EmployeeRepository>(
    (ref) => EmployeeRepositoryImpl(ref.read));

//インターフェース
abstract class EmployeeRepository {
  Future<List<Employee>> getEmployees(String email, String password);
}

//実装クラス
class EmployeeRepositoryImpl implements EmployeeRepository {
  final Reader _read;
  EmployeeRepositoryImpl(this._read);

  //取得
  Future<List<Employee>> getEmployees(String email, String password) async {
    var conn = await _read(mysqlConnetionRepository).connectMySql();

    var sql =
        "select Id,Name,Email from Employees where Email = ? and Password = ?";
    var employee = await conn.query(sql, [email, password]);
    conn.close();

    return employee.map((e) => Employee.fromMap(e.fields)).toList();
  }
}
