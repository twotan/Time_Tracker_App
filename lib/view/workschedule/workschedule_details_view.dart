import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_tracker_app/model/workschedule.dart';
import 'package:time_tracker_app/provider/workschedule_provider.dart';
import 'package:time_tracker_app/view/workschedule/workschedule_input_dialog.dart';

class WorkScheduleDetailsView extends ConsumerStatefulWidget {
  @override
  _WorkScheduleDetailsState createState() => _WorkScheduleDetailsState();
}

class _WorkScheduleDetailsState extends ConsumerState<WorkScheduleDetailsView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    ref.read(workScheduleViewController).initState();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ja');
    final year = ref.watch(currentYearState)!;
    final month = ref.watch(currentMonthState)!;
    final int days =
        DateTime(ref.watch(currentYearState)!, ref.watch(currentMonthState)!, 1)
            .add(Duration(days: -1))
            .day;
    final List<WorkSchedule>? schedules =
        ref.watch(sortedWorkScheduleListState);
    return Scaffold(
        appBar: AppBar(
          title: Text('${year}年${month}月'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Routemaster.of(context).pop();
              }),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              child: TableCalendar(
            //言語指定
            locale: 'ja_JP',
            calendarFormat: CalendarFormat.month,
            firstDay: DateTime.utc(year, month, 1),
            lastDay: DateTime.utc(year, month, days),
            focusedDay: DateTime.utc(year, month, 1),
            //ヘッダー中央寄せ＆フォーマット変更ボタン非表示
            headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                leftChevronIcon: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    if (month != 1) {
                      ref
                          .watch(workScheduleViewController)
                          .setCurrentMonth(month - 1);
                      ref.read(workScheduleViewController).initState();
                    }
                  },
                ),
                rightChevronIcon: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    if (month != 12) {
                      ref
                          .watch(workScheduleViewController)
                          .setCurrentMonth(month + 1);
                      ref.read(workScheduleViewController).initState();
                    }
                  },
                )),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
          )),
          SizedBox(height: 10.0),
          Container(
              height: 3000,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: schedules?.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = schedules![index];
                  return Card(
                    child: ListTile(
                      title: Text('${data.month}月${data.day}日'),
                      subtitle: Row(children: [
                        Expanded(
                            child: Text(
                                '${DateFormat.Hms().format(data.startTime)} ～ ${DateFormat.Hms().format(data.endTime)}')),
                        Expanded(
                            child: Text(
                          '${data.overHour}',
                          style: TextStyle(color: Colors.red),
                        ))
                      ]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.check_circle),
                            onPressed: () {
                              /* _id = data.id;
                              _startTime = data.startTime;
                              _endTime = data.endTime;
                              _restTime = data.restTime;
                              _workTime = data.workMinute;*/
                              ref.read(workScheduleState.notifier).state = data;
                              showDialog(
                                context: context,
                                builder: (_) => WorkScheduleInputDialog(),
                              );
                              //showInputDialog(context, ref);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ))
        ])));
  }
}
