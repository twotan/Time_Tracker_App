import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:time_tracker_app/provider/login_provider.dart';

class NotFoundPage extends ConsumerWidget {
  const NotFoundPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        child: Text('NotFound'),
        onPressed: () async {
          var result = await ref.read(loginViewController).signOut();

          if (result) {
            Routemaster.of(context).push('/');
          }
        },
      ),
    );
  }
}
