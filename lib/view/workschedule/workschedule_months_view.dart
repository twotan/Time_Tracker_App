import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:time_tracker_app/provider/workschedule_provider.dart';

class WorkScheduleMonthsView extends ConsumerStatefulWidget {
  @override
  _WorkScheduleMonthsState createState() => _WorkScheduleMonthsState();
}

class _WorkScheduleMonthsState extends ConsumerState<WorkScheduleMonthsView> {
  final List<int> months = List.generate(12, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    var year = ref.watch(currentYearState);
    return Scaffold(
      appBar: AppBar(
        title: Text('勤務表（${year}年）'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Routemaster.of(context).pop();
            }),
      ),
      body: Container(
        width: double.infinity,
        child: ListView.builder(
          itemCount: months.length,
          itemBuilder: (BuildContext context, int index) {
            final month = months[index];
            return Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('${year}年${month}月'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.check_circle),
                      tooltip: 'WorkScheduleDetailsView',
                      onPressed: () {
                        ref
                            .watch(workScheduleViewController)
                            .setCurrentYear(year!);
                        ref
                            .watch(workScheduleViewController)
                            .setCurrentMonth(month);
                        Routemaster.of(context).push('details');
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
