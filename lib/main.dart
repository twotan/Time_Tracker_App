import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:time_tracker_app/view/approute.dart';
import 'package:time_tracker_app/view/settings_view.dart';
import 'package:time_tracker_app/view/workschedule/workschedule_years_view.dart';

final pageProvider = Provider<List<Widget>>((ref) {
  return const [
    WorkScheduleYearsView(),
    SettingPage(),
  ];
});

final pageTitleProvider = Provider<List<Widget>>((ref) {
  return const [
    Text('勤務表'),
    Text('設定'),
  ];
});

void main() async {
  /* WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = firestore.collection('Users');
  final querySnapshot = await users.get(); // QuerySnapshot
  final queryDocSnapshot = querySnapshot.docs; // List<QueryDocumentSnapshot>
  for (final snapshot in queryDocSnapshot) {
    final data = snapshot.data(); // `data()`で中身を取り出す
  }*/

  /*await firestore.collection('Users').doc() // ここは空欄だと自動でIDが付く
      .set({
    'name': 'sato',
    'age': 20,
    'sex': 'male',
    'type': ['A', 'B']
  }); // データ*/

  //プロバイダーを読み取れるように全体をラップする
  runApp(
    const ProviderScope(
      child: AppRoute(),
    ),
  );
}

class TopPage extends ConsumerStatefulWidget {
  TopPage(this._currentbnb);
  int _currentbnb;

  @override
  _TopPageState createState() => _TopPageState(_currentbnb);
}

class _TopPageState extends ConsumerState<TopPage> {
  _TopPageState(this._currentbnb);
  int _currentbnb;

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(pageProvider);
    ref.read(pageTitleProvider);
  }

  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(pageProvider);
    final titles = ref.watch(pageTitleProvider);

    return Scaffold(
      appBar:
          AppBar(title: titles[_currentbnb], automaticallyImplyLeading: false),
      body: SafeArea(
        child: pages[_currentbnb],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          setState(
            () => {
              //_currenttabの更新だけでも画面は切り替わるがroutemasterの制御を維持するためにパスも更新
              if (index == 0)
                {Routemaster.of(context).push('/schedules')}
              else if (index == 1)
                {Routemaster.of(context).push('/settings')},
              _currentbnb = index
            },
          )
        },
        currentIndex: _currentbnb,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
