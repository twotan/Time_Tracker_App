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
  const WorkScheduleDetailsView({Key? key}) : super(key: key);

  @override
  _WorkScheduleDetailsState createState() => _WorkScheduleDetailsState();
}

class _WorkScheduleDetailsState extends ConsumerState<WorkScheduleDetailsView> {
  DateTime? _selectedDay;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    ref.read(workScheduleViewController).initState();
    ref.read(workScheduleProgressViewController).initState(ref.read(currentYearState)!, ref.read(currentMonthState)!);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    initializeDateFormatting('ja');
    final year = ref.watch(currentYearState)!;
    final month = ref.watch(currentMonthState)!;
    final progress = ref.watch(workScheduleProgressState);
    final int days = DateTime(year, month, 1).add(const Duration(days: -1)).day;
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
              animatedIconTheme: const IconThemeData(size: 22.0),
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
                          String? message;
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, right: 20, left: 20),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          topLeft: Radius.circular(20.0))),
                                  height: screenSize.height * 0.3,
                                  child: Column(
                                    // 均等配置
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextFormField(
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 4,
                                            minLines: 1,
                                            decoration: InputDecoration(
                                              hintText: "Message ✍️"
                                            ),
                                            onChanged: (String value) {
                                              // Providerから値を更新
                                              message = value;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              minimumSize: const Size.fromHeight(50)
                                            ),
                                            onPressed: () async {
                                              await ref
                                                  .read(
                                                      workScheduleProgressViewController)
                                                  .update(progress.copyWith(
                                                      status: 1),message);
                                              Navigator.pop(context);
                                              ref.read(workScheduleProgressViewController).initState(year, month);
                                            },
                                            child: const Text('提出'),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ));
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
                          String? message;
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, right: 20, left: 20),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          topLeft: Radius.circular(20.0))),
                                  height: screenSize.height * 0.3,
                                  child: Column(
                                    // 均等配置
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextFormField(
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 4,
                                            minLines: 1,
                                            decoration: InputDecoration(
                                                hintText: "Message ✍️"
                                            ),
                                            onChanged: (String value) {
                                              // Providerから値を更新
                                              message = value;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                minimumSize: const Size.fromHeight(50)
                                            ),
                                            onPressed: () async {
                                              await ref
                                                  .read(
                                                      workScheduleProgressViewController)
                                                  .update(progress.copyWith(
                                                      status: 0),message);
                                              ref.read(workScheduleProgressViewController).initState(year, month);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('申請'),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ));
                              });
                        },
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.w500))
              ],
            ),
            appBar: AppBar(
              title: Text('${year!}年${month!}月'),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
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
                        Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor),
                            padding:
                                const EdgeInsets.only(right: 5.0, left: 5.0),
                            height: screenSize.height * 0.70,
                            child: TableCalendar(
                              //言語指定
                              locale: 'ja_JP',
                              calendarFormat: CalendarFormat.month,
                              firstDay: DateTime(year, month, 1),
                              lastDay:
                                  DateTime(year, month, days),
                              focusedDay:
                                  DateTime(year, month, 1),
                              //ヘッダー中央寄せ＆フォーマット変更ボタン非表示
                              headerStyle: HeaderStyle(
                                  titleCentered: true,
                                  formatButtonVisible: false,
                                  leftChevronIcon: IconButton(
                                    icon: const Icon(Icons.arrow_back_ios),
                                    onPressed: () {
                                      if (month != 1) {
                                        ref
                                            .watch(workScheduleViewController)
                                            .setCurrentMonth(month - 1);
                                        ref
                                            .read(workScheduleViewController)
                                            .initState();
                                        ref.read(workScheduleProgressViewController).initState(year, month - 1);
                                        isDialOpen.value = false;
                                      }
                                    },
                                  ),
                                  rightChevronIcon: IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    onPressed: () {
                                      if (month != 12) {
                                        ref
                                            .watch(workScheduleViewController)
                                            .setCurrentMonth(month + 1);
                                        ref
                                            .read(workScheduleViewController)
                                            .initState();
                                        ref.read(workScheduleProgressViewController).initState(year,month + 1);
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
                                  });
                                }

                                if(selectedDay.month == month){
                                  var schedule = schedules!.firstWhere(
                                          (element) =>
                                      element.month ==
                                          selectedDay.month &&
                                          element.day == selectedDay.day);
                                  ref.read(workScheduleState.notifier).state =
                                      schedule;
                                  if(progress.status != 1){
                                    showDialog(
                                      context: context,
                                      builder: (_) => const WorkScheduleInputDialog(),
                                    );
                                  }
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
                                        child:Column(
                                              children: <Widget>[
                                                const Spacer(),
                                                Text('${(totalWorkMinute ~/ 60).toString().padLeft(2, "0")}:${(totalWorkMinute % 60).toString().padLeft(2, "0")}',
                                                    style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black54)),
                                                const Text('勤務時間',
                                                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800,color: Colors.black45)),
                                                const Spacer(),
                                              ],
                                            )),
                                    const VerticalDivider(
                                      color: Colors.black,
                                      thickness: 0,
                                      width: 20,
                                      indent: 20,
                                      endIndent: 20,
                                    ),
                                    Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            const Spacer(),
                                            Text('${(totalOverMinute ~/ 60).toString().padLeft(2, "0")}:${(totalOverMinute % 60).toString().padLeft(2, "0")}',
                                                style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black54)),
                                            const Text('超過時間',
                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800,color: Colors.black45)),
                                            const Spacer(),
                                          ],
                                        ))
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
                                style: const TextStyle(color: Colors.red),
                              ))
                            ]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if(progress.status < 1)
                                IconButton(
                                  icon: Icon(Icons.check_circle,color: (DateTime.now().compareTo(DateTime(year,month,data.day + 1)) >= 0) ? Theme.of(context).primaryColor : Colors.grey),
                                  onPressed: () {
                                    ref.read(workScheduleState.notifier).state =
                                        data;
                                    showDialog(
                                      context: context,
                                      builder: (_) => const WorkScheduleInputDialog(),
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
