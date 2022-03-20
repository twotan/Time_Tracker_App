import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../provider/workschedule_provider.dart';

class WorkScheduleYearsView extends ConsumerStatefulWidget {
  const WorkScheduleYearsView({Key? key}) : super(key: key);
  @override
  ConsumerState<WorkScheduleYearsView> createState() =>
      _WorkScheduleYearsState();
}

class _WorkScheduleYearsState extends ConsumerState<WorkScheduleYearsView> {
  @override
  void initState() {
    super.initState();
    ref.read(workScheduleViewController).initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<int> years = ref.watch(workScheduleYearListState);
    return Scaffold(
        body: Container(
            width: double.infinity,
            child: ListView.builder(
              itemCount: years.length,
              itemBuilder: (BuildContext context, int index) {
                final year = years[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('${year}年'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.check_circle),
                          tooltip: 'WorkScheduleMonthsView',
                          onPressed: () {
                            ref
                                .watch(workScheduleViewController)
                                .setCurrentYear(year);
                            Routemaster.of(context).push('months');
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )));
  }
}
