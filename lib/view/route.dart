import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker_app/view/settings_view.dart';

import '../main.dart';
import 'login_view.dart';

final buttonIdProvider = StateProvider((ref) => 0);

class Navigator2test extends ConsumerWidget {
  const Navigator2test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var buttonId = ref.watch(buttonIdProvider);
    return MaterialApp(
      title: 'Time Tracker',
      //宣言的な画面遷移の管理部分
      //buttonIdの値によって変化する
      home: Navigator(
        pages: [
          const MaterialPage(
            child: LoginView(),
          ),
          if (buttonId == 1)
            MaterialPage(
              child: TopPage(0),
            ),
          if (buttonId == 2)
            MaterialPage(
              child: TopPage(1),
            ),
          if (buttonId == 3)
            const MaterialPage(
              child: SettingPage(),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          ref.read(buttonIdProvider.state).state = 0;
          return true;
        },
      ),
    );
  }
}

class MenuPage extends ConsumerWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  ref.read(buttonIdProvider.state).state = 1;
                },
                child: const Text('Page1')),
            ElevatedButton(
                onPressed: () {
                  ref.read(buttonIdProvider.state).state = 2;
                },
                child: const Text('Page2')),
            ElevatedButton(
                onPressed: () {
                  ref.read(buttonIdProvider.state).state = 3;
                },
                child: const Text('Page3')),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page1'),
      ),
      backgroundColor: Colors.red,
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page2'),
      ),
      backgroundColor: Colors.blue,
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page3'),
      ),
      backgroundColor: Colors.green,
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
