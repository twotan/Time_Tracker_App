import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker_app/provider/workschedule_provider.dart';

class WorkScheduleInputDialog extends ConsumerWidget {
  const WorkScheduleInputDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var schedule = ref.watch(workScheduleState);
    return AlertDialog(
      title: Text('勤怠入力'),
      content: SizedBox(
          height: 200,
          child: Container(
              width: double.maxFinite,
              child: ListView(children: [
                ListTile(
                    leading: Text("出社"),
                    title: Text(
                        "${DateFormat('HH:mm').format(schedule!.startTime)}"),
                    trailing: TextButton(
                      child: Text('変更',
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                      onPressed: () async {
                        Picker(
                          adapter: DateTimePickerAdapter(
                              type: PickerDateTimeType.kHMS,
                              value: schedule!.startTime,
                              customColumnType: [3, 4]),
                          cancelText: "キャンセル",
                          confirmText: "選択",
                          onConfirm: (Picker picker, List value) {
                            var startTime = schedule.startTime;
                            ref.read(workScheduleViewController).setSchedule(
                                schedule.copyWith(
                                    startTime: DateTime.utc(
                                        startTime.year,
                                        startTime.month,
                                        startTime.day,
                                        value[0],
                                        value[1],
                                        0)));
                          },
                        ).showModal(context);
                      },
                    )),
                ListTile(
                    leading: Text("退社"),
                    title:
                        Text("${DateFormat('HH:mm').format(schedule.endTime)}"),
                    trailing: TextButton(
                      child: Text('変更',
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                      onPressed: () async {
                        Picker(
                          adapter: DateTimePickerAdapter(
                              type: PickerDateTimeType.kHMS,
                              value: schedule.endTime,
                              customColumnType: [3, 4]),
                          cancelText: "キャンセル",
                          confirmText: "選択",
                          onConfirm: (Picker picker, List value) {
                            var endTime = schedule.endTime;
                            ref.read(workScheduleViewController).setSchedule(
                                schedule.copyWith(
                                    endTime: DateTime.utc(
                                        endTime.year,
                                        endTime.month,
                                        endTime.day,
                                        value[0],
                                        value[1],
                                        0)));
                          },
                        ).showModal(context);
                      },
                    )),
                ListTile(
                    leading: Text("休憩"),
                    title: Text(
                        "${DateFormat('HH:mm').format(schedule.restTime)}"),
                    trailing: TextButton(
                      child: Text('変更',
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                      onPressed: () async {
                        Picker(
                          adapter: DateTimePickerAdapter(
                              type: PickerDateTimeType.kHMS,
                              value: schedule.restTime,
                              customColumnType: [3, 4]),
                          cancelText: "キャンセル",
                          confirmText: "選択",
                          onConfirm: (Picker picker, List value) {
                            var restTime = schedule.restTime;
                            ref.read(workScheduleViewController).setSchedule(
                                schedule.copyWith(
                                    restTime: DateTime.utc(
                                        restTime.year,
                                        restTime.month,
                                        restTime.day,
                                        value[0],
                                        value[1],
                                        0)));
                          },
                        ).showModal(context);
                      },
                    )),
                ListTile(
                  leading: Text("勤務"),
                  title: Text(
                      "${(schedule.workMinute ~/ 60).toString().padLeft(2, "0")}:${(schedule.workMinute % 60).toString().padLeft(2, "0")}"),
                ),
                ListTile(
                  leading: Text("超過"),
                  title: Text(
                      "${schedule.workMinute > 480 ? "${((schedule.workMinute - 480) ~/ 60).toString().padLeft(2, "0")}:${((schedule.workMinute - 480) % 60).toString().padLeft(2, "0")}" : "00:00"}"),
                )
              ]))),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            await ref.read(workScheduleViewController).update(schedule);
            await ref.read(workScheduleViewController).initState();
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
