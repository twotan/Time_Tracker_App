import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:time_tracker_app/view/notfound_page.dart';
import 'package:time_tracker_app/view/workschedule/workschedule_details_view.dart';
import 'package:time_tracker_app/view/workschedule/workschedule_months_view.dart';

import '../main.dart';
import '../provider/login_provider.dart';
import 'login_view.dart';

//ログイン時のRouteMap
final loginMap = RouteMap(
    onUnknownRoute: (_) => const MaterialPage(child: NotFoundPage()),
    routes: {
      "/schedules": (routeData) => MaterialPage(child: TopPage(0)),
      "/schedules/months": (routeData) =>
          MaterialPage(child: WorkScheduleMonthsView()),
      "/schedules/months/details": (routeData) =>
          MaterialPage(child: WorkScheduleDetailsView()),
      "/settings": (routeData) => MaterialPage(child: TopPage(1)),
    });

//ログアウト時のRouteMap
final logoutMap = RouteMap(
    onUnknownRoute: (_) => const Redirect('/'),
    routes: {'/': (_) => const MaterialPage(child: LoginView())});

class AppRoute extends ConsumerWidget {
  const AppRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(loginState);
    final ThemeData lightTheme = ThemeData.light();
    final ThemeData darkTheme = ThemeData.dark();
    return MaterialApp.router(
      //TODO:カスタマイズ
      theme: lightTheme.copyWith(
          backgroundColor: Colors.white,
          primaryColor: Colors.blue,
          primaryColorLight: Colors.blue.shade50,
          colorScheme: lightTheme.colorScheme
              .copyWith(secondary: Colors.amberAccent.shade200),
          scaffoldBackgroundColor: Colors.white,
          disabledColor: Colors.grey),
      darkTheme: darkTheme.copyWith(
          backgroundColor: Colors.grey,
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white54),
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) => isLogin ? loginMap : logoutMap,
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}

class MyObserver extends RoutemasterObserver {
  // RoutemasterObserver extends NavigatorObserver and
  // receives all nested Navigator events
  @override
  void didPop(Route route, Route? previousRoute) {
    print('Popped a route');
  }

  // Routemaster-specific observer method
  @override
  void didChangeRoute(RouteData routeData, Page page) {
    print('New route: ${routeData.path}');
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: tabPage.controller,
          tabs: [
            Tab(text: 'Feed'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabPage.controller,
        children: [],
      ),
    );
  }
}
