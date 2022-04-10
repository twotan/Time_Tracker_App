import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_tracker_app/model/workschedule.dart';
import 'package:time_tracker_app/provider/workschedule_provider.dart';
import 'package:time_tracker_app/provider/workscheduleprogress_provider.dart';
import 'package:time_tracker_app/view/workschedule/workschedule_input_dialog.dart';

class _StickyContainerBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyContainerBarDelegate({required this.container});

  final Container container;

  @override
  double get minExtent => container.constraints!.minHeight;

  @override
  double get maxExtent => container.constraints!.maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return container;
  }

  @override
  bool shouldRebuild(_StickyContainerBarDelegate oldDelegate) {
    return container != oldDelegate.container;
  }
}

class WorkScheduleDetailsView extends ConsumerStatefulWidget {
  @override
  _WorkScheduleDetailsState createState() => _WorkScheduleDetailsState();
}

class _WorkScheduleDetailsState extends ConsumerState<WorkScheduleDetailsView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    ref.read(workScheduleViewController).initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<int> months = List.generate(12, (index) => index + 1);
    var screenSize = MediaQuery.of(context).size;
    initializeDateFormatting('ja');
    final year = ref.watch(currentYearState)!;
    final month = ref.watch(currentMonthState)!;
    ref.read(workScheduleProgressViewController).initState(year, month);
    final progress = ref.watch(workScheduleProgressState);
    final int days = DateTime(year, month, 1).add(Duration(days: -1)).day;
    final List<WorkSchedule>? schedules =
        ref.watch(sortedWorkScheduleListState);

    final int totalWorkMinute = schedules!.fold(0,
        (value, element) => int.parse(value!.toString()) + element.workMinute);

    final int totalOverMinute = schedules!.fold(
        0,
        (value, element) =>
            int.parse(value!.toString()) +
            (element.workMinute > 480 ? (element.workMinute - 480) : 0));
    return (progress == null)
        ? const Text('')
        : Scaffold(
            floatingActionButton: SpeedDial(
              openCloseDial: isDialOpen,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 22.0),
              curve: Curves.bounceIn,
              renderOverlay: false,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              children: [
                (progress.status == 0)
                    ? SpeedDialChild(
                        child: const Icon(Icons.create),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        label: "勤務表を提出する",
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: screenSize.height * 0.4,
                                  child: Column(
                                    // 均等配置
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('キャンセル'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await ref
                                                  .read(
                                                      workScheduleProgressViewController)
                                                  .update(progress.copyWith(
                                                      status: 1));
                                              Navigator.pop(context);
                                            },
                                            child: Text('提出'),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.w500))
                    : SpeedDialChild(
                        child: const Icon(Icons.create),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        label: "勤務表の訂正申請をする",
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: screenSize.height * 0.4,
                                  child: Column(
                                    // 均等配置
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('キャンセル'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await ref
                                                  .read(
                                                      workScheduleProgressViewController)
                                                  .update(progress.copyWith(
                                                      status: 0));
                                              Navigator.pop(context);
                                            },
                                            child: Text('申請'),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.w500))
              ],
            ),
            appBar: AppBar(
              title: Text('${year}年${month}月'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Routemaster.of(context).pop();
                  }),
            ),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        /*Container(
                            padding: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(color: Colors.white),
                            height: screenSize.height * 0.1,
                            child: ListView.builder(
                              padding: EdgeInsets.all(10.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: months.length,
                              itemBuilder: (BuildContext context, int index) {
                                final month = months[index];
                                return ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.grey),
                                    shape:
                                        MaterialStateProperty.all<CircleBorder>(
                                      CircleBorder(),
                                    ),
                                  ),
                                  onPressed: () {
                                    ref
                                        .watch(workScheduleViewController)
                                        .setCurrentMonth(month + 1);
                                    ref
                                        .read(workScheduleViewController)
                                        .initState();
                                    isDialOpen.value = false;
                                  },
                                  child: Text('${month}月'),
                                );
                              },
                            )),*/
                        Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor),
                            padding:
                                const EdgeInsets.only(right: 5.0, left: 5.0),
                            height: screenSize.height * 0.55,
                            child: TableCalendar(
                              //言語指定
                              locale: 'ja_JP',
                              calendarFormat: CalendarFormat.month,
                              firstDay: DateTime.utc(year, month, 1).toLocal(),
                              lastDay:
                                  DateTime.utc(year, month, days).toLocal(),
                              focusedDay:
                                  DateTime.utc(year, month, 1).toLocal(),
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
                                        ref
                                            .read(workScheduleViewController)
                                            .initState();
                                        isDialOpen.value = false;
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
                                        ref
                                            .read(workScheduleViewController)
                                            .initState();
                                        isDialOpen.value = false;
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
                                    var schedule = schedules!.firstWhere(
                                        (element) =>
                                            element.month ==
                                                selectedDay.month &&
                                            element.day == selectedDay.day);
                                    ref.read(workScheduleState.notifier).state =
                                        schedule;
                                    showDialog(
                                      context: context,
                                      builder: (_) => WorkScheduleInputDialog(),
                                    );
                                  });
                                }
                              },
                            )),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyContainerBarDelegate(
                          container: Container(
                              padding: EdgeInsets.only(
                                  top: 5, right: 2, left: 2, bottom: 10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor),
                              height: screenSize.height * 0.15,
                              child: Card(
                                  color: Theme.of(context).primaryColorLight,
                                  elevation: 5,
                                  child: Row(children: [
                                    Expanded(
                                        child: ListTile(
                                      title: Text(
                                          '${(totalWorkMinute ~/ 60).toString().padLeft(2, "0")}:${(totalWorkMinute % 60).toString().padLeft(2, "0")}'),
                                      subtitle: Row(children: [Text('勤務時間')]),
                                    )),
                                    Expanded(
                                        child: VerticalDivider(
                                      color: Colors.black,
                                      thickness: 1,
                                      width: 20,
                                      indent: 20,
                                      endIndent: 20,
                                    )),
                                    Expanded(
                                        child: Center(
                                            child: ListTile(
                                      title: Text(
                                          '${(totalOverMinute ~/ 60).toString().padLeft(2, "0")}:${(totalOverMinute % 60).toString().padLeft(2, "0")}'),
                                      subtitle: Row(children: [Text('超過時間')]),
                                    )))
                                  ])))))
                ];
              },
              body: Column(children: <Widget>[
                Expanded(
                    flex: 9,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 10, right: 5.0, left: 5.0, bottom: 50.0),
                      physics: const NeverScrollableScrollPhysics(),
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
                                "${data.workMinute > 480 ? "${((data.workMinute - 480) ~/ 60).toString().padLeft(2, "0")}:${((data.workMinute - 480) % 60).toString().padLeft(2, "0")}" : "00:00"}",
                                style: TextStyle(color: Colors.red),
                              ))
                            ]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.check_circle),
                                  onPressed: () {
                                    ref.read(workScheduleState.notifier).state =
                                        data;
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
                    )),
              ]),
            ),
          );
  }
}
