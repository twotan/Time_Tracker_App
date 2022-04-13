import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker_app/repository/session_repository.dart';
import 'package:time_tracker_app/repository/workscheduleprogress_repository.dart';

import '../constants.dart';
import '../model/workscheduleprogress.dart';

final _workScheduleProgressState =
    StateProvider<WorkScheduleProgress?>((ref) => null);

final workScheduleProgressState = StateProvider<WorkScheduleProgress?>((ref) {
  return ref.watch(_workScheduleProgressState);
});

final _workScheduleProgressListState =
    StateProvider<List<WorkScheduleProgress>?>((ref) => null);

//viewで呼び出されるプロバイダー
final workScheduleProgressViewController =
    Provider.autoDispose((ref) => WorkScheduleProgressViewController(ref.read));

class WorkScheduleProgressViewController {
  final Reader _read;
  WorkScheduleProgressViewController(this._read);

  Future<void> initState(int year, int month) async {
    final prefs = await SharedPreferences.getInstance();
    var sessionKey = await prefs.getString(SharedPreferencesKeys.loginKey);

    if (sessionKey != null) {
      var sessions = await _read(sessionRepository).getSessions(sessionKey);
      if (sessions != null) {
        var session = sessions.first;

        var progress = await _read(workScheduleProgressRepository)
            .getWorkScheduleProgressList(
                year: year, month: month, employeeId: session.employeeId);
        _read(_workScheduleProgressListState.notifier).state = progress;
        _read(_workScheduleProgressState.notifier).state = progress.first;
      }
    }
  }

  void dispose() {
    _read(_workScheduleProgressListState)?.clear();
  }

  Future<void> update(WorkScheduleProgress progress,String? message) async {
    try {
      await _read(workScheduleProgressRepository)
          .updateWorkScheduleProgress(progress,message);
    } catch (e) {
      print(e); //エラー内容が出力
    }
  }
}
