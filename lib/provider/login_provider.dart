import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker_app/repository/session_repository.dart';
import 'package:time_tracker_app/constants.dart';
import 'package:time_tracker_app/model/session.dart';
import 'package:time_tracker_app/repository/employee_repository.dart';
import 'package:uuid/uuid.dart';

final _infoTextState = StateProvider<String?>((ref) => null);

final infoTextState = StateProvider<String?>((ref) {
  return ref.watch(_infoTextState);
});

final _emailState = StateProvider<String?>((ref) => null);

final emailState = StateProvider<String?>((ref) {
  return ref.watch(_emailState);
});

final _passwordState = StateProvider<String?>((ref) => null);

final passwordState = StateProvider<String?>((ref) {
  return ref.watch(_passwordState);
});

final _loginState = StateProvider<bool>((ref) => false);

final loginState = StateProvider<bool>((ref) {
  return ref.watch(_loginState);
});

//viewで呼び出されるプロバイダー
final loginViewController =
    Provider.autoDispose((ref) => LoginViewController(ref.read));

class LoginViewController {
  final Reader _read;
  LoginViewController(this._read);

  void dispose() {
    _read(_infoTextState.notifier).state = null;
    _read(_emailState.notifier).state = null;
    _read(_passwordState.notifier).state = null;
  }

  Future<bool> signIn() async {
    var email = _read(_emailState);
    var password = _read(_passwordState);
    var employees = await _read(employeeRepository)
        .getEmployees(email ?? "", password ?? "");

    if (employees.isNotEmpty) {
      var employee = employees.first;
      var uuid = Uuid().v1();

      try {
        await _read(sessionRepository).addSession(
            Session(id: 0, sessionKey: uuid, employeeId: employee.id));

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(SharedPreferencesKeys.loginKey, uuid);
        await notifierLoginState();

        return true;
      } catch (e) {
        _read(_infoTextState.notifier).state = "ログイン失敗";
        return false;
      }
    } else {
      _read(_infoTextState.notifier).state = "ログイン失敗";
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPreferencesKeys.loginKey);
      await notifierLoginState();
      return true;
    } catch (e) {
      return false;
    }
  }

  void setEmail(String email) {
    _read(_emailState.notifier).state = email;
  }

  void setPassword(String password) {
    _read(_passwordState.notifier).state = password;
  }

  Future<void> notifierLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.containsKey(SharedPreferencesKeys.loginKey);
    _read(_loginState.notifier).state = result;
  }
}
