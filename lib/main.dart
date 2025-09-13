import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash/view.dart';

const kAccountKey = 'account';
const kPasswordKey = 'password';
const kFailedCountKey = 'failed_count';


Future<void> main() async {
  // 暫時使用16個1的字串當key 之後可以更換
  await EncryptedSharedPreferencesAsync.initialize("1111111111111111");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashPage(),
    );
  }
}
