import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:time_tracker_app/provider/login_provider.dart';

class LoginView extends ConsumerWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerから値を受け取る
    final infoText = ref.watch(infoTextState);

    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  // Providerから値を更新
                  ref.read(loginViewController).setEmail(value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  // Providerから値を更新
                  ref.read(loginViewController).setPassword(value);
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(infoText ?? ""),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('ログイン'),
                  onPressed: () async {
                    var result = await ref.read(loginViewController).signIn();

                    if (result) {
                      ref.read(loginViewController).dispose();
                      Routemaster.of(context).push('/schedules');
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  child: Text('テストログイン'),
                  onPressed: () async {
                    ref
                        .read(loginViewController)
                        .setEmail("moriya-tsuyoshi@activefusions.com");
                    ref.read(loginViewController).setPassword("123456");
                    var result = await ref.read(loginViewController).signIn();

                    if (result) {
                      ref.read(loginViewController).dispose();
                      Routemaster.of(context).push('/schedules');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
