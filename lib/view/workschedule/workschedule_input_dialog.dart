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
    var date = DateTime(schedule!.year, schedule.month, schedule.day);
    var screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text('${DateFormat.MMMEd('ja').format(date)}'),
      content: SizedBox(
          height: screenSize.height * 0.4,
          child: Container(
              width: double.maxFinite,
              child: ListView(children: [
                ListTile(
                    leading: const Text("出社"),
                    title: Text(
                        "${DateFormat('HH:mm').format(schedule!.startTime)}"),
                    trailing: TextButton(
                      child: const Text('変更',
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
                                    startTime: DateTime(
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
                    leading: const Text("退社"),
                    title:
                        Text("${DateFormat('HH:mm').format(schedule.endTime)}"),
                    trailing: TextButton(
                      child: const Text('変更',
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
                                    endTime: DateTime(
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
                    leading: const Text("休憩"),
                    title:  Text(
                        "${DateFormat('HH:mm').format(schedule.restTime)}"),
                    trailing: TextButton(
                      child: const Text('変更',
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
                                    restTime: DateTime(
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
                  leading: const Text("勤務"),
                  title: Text(
                      "${(schedule.workMinute ~/ 60).toString().padLeft(2, "0")}:${(schedule.workMinute % 60).toString().padLeft(2, "0")}"),
                ),
                ListTile(
                  leading: const Text("超過"),
                  title: Text(
                      "${schedule.workMinute > 480 ? "${((schedule.workMinute - 480) ~/ 60).toString().padLeft(2, "0")}:${((schedule.workMinute - 480) % 60).toString().padLeft(2, "0")}" : "00:00"}"),
                )
              ]))),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            await ref.read(workScheduleViewController).update(schedule);
            await ref.read(workScheduleViewController).initState();
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
