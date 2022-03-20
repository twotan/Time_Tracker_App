import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker_app/repository/workschedule_repository.dart';
import 'package:time_tracker_app/model/workschedule.dart';
import 'package:time_tracker_app/repository/session_repository.dart';

import '../constants.dart';

enum SortOrder {
  ASC,
  DESC,
}

final _workScheduleState = StateProvider<WorkSchedule?>((ref) => null);

final workScheduleState = StateProvider<WorkSchedule?>((ref) {
  return ref.watch(_workScheduleState);
});

final _sortOrderState = StateProvider<SortOrder>((ref) => SortOrder.ASC);

final _workScheduleListState =
    StateProvider<List<WorkSchedule>?>((ref) => null);

final _workScheduleYearListState = StateProvider<List<int>>((ref) => []);

final sortedWorkScheduleListState = StateProvider<List<WorkSchedule>?>((ref) {
  final List<WorkSchedule>? workScheduleList =
      ref.watch(_workScheduleListState);
  /*if (ref.watch(_sortOrderState) == SortOrder.ASC) {
    workScheduleList?.sort((a, b) => a.startTime.compareTo(b.startTime));
  } else {
    workScheduleList?.sort((a, b) => b.startTime.compareTo(a.startTime));
  }*/
  return workScheduleList ?? [];
});

final _currentYearState = StateProvider<int?>((ref) => null);

final currentYearState = StateProvider<int?>((ref) {
  return ref.watch(_currentYearState);
});

final _currentMonthState = StateProvider<int?>((ref) => null);

final currentMonthState = StateProvider<int?>((ref) {
  return ref.watch(_currentMonthState);
});

final workScheduleYearListState = StateProvider<List<int>>((ref) {
  final List<int> workScheduleListState = ref.watch(_workScheduleYearListState);

  return workScheduleListState ?? [];
});

//viewで呼び出されるプロバイダー
final workScheduleViewController =
    Provider.autoDispose((ref) => WorkScheduleViewController(ref.read));

class WorkScheduleViewController {
  final Reader _read;
  WorkScheduleViewController(this._read);

  Future<void> initState() async {
    final prefs = await SharedPreferences.getInstance();
    var sessionKey = await prefs.getString(SharedPreferencesKeys.loginKey);

    if (sessionKey != null) {
      var sessions = await _read(sessionRepository).getSessions(sessionKey);
      if (sessions != null) {
        var session = sessions.first;

        var year = _read(_currentYearState);
        var month = _read(_currentMonthState);
        _read(_workScheduleListState.notifier).state =
            await _read(workScheduleRepository).getWorkScheduleList(
                year: year, month: month, employeeId: session.employeeId);
        _read(workScheduleYearListState.notifier).state =
            await _read(workScheduleRepository)
                .getWorkScheduleYearList(employeeId: session.employeeId);
      }
    }
  }

  void dispose() {
    _read(_workScheduleListState)?.clear();
  }

  //TODO:修正必須
  Future<void> add(TextEditingController textController) async {
    final String text = textController.text;
    if (text.trim().isEmpty) {
      return;
    }
    textController.text = '';
    final now = DateTime.now();
    final newWorkSchedule = WorkSchedule(
      id: 1,
      year: 2022,
      month: 2,
      day: 1,
      startTime: now,
      endTime: now,
      restTime: now,
    );
    final List<WorkSchedule> newWorkScheduleList = [
      newWorkSchedule,
      ...(_read(_workScheduleListState) ?? [])
    ];
    _read(_workScheduleListState.notifier).state = newWorkScheduleList;
    await _read(workScheduleRepository).saveTodoList(newWorkScheduleList);
  }

  Future<void> update(WorkSchedule workSchedule) async {
    try {
      await _read(workScheduleRepository).updateWorkSchedule(workSchedule);
    } catch (e) {
      print(e); //エラー内容が出力
    }
  }

  void toggleSortOrder() {
    _read(_sortOrderState.notifier).state =
        _read(_sortOrderState) == SortOrder.ASC
            ? SortOrder.DESC
            : SortOrder.ASC;
  }

  void setCurrentYear(int year) {
    _read(_currentYearState.notifier).state = year;
  }

  void setCurrentMonth(int month) {
    _read(_currentMonthState.notifier).state = month;
  }

  void setSchedule(WorkSchedule schedule) {
    _read(_workScheduleState.notifier).state = schedule;
  }
}
