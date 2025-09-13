import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecloudseal_proj/login/view.dart';

import 'logic.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeLogic logic = Get.put(HomeLogic());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首頁'),
        actions: [
          IconButton(
            tooltip: '登出',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = EncryptedSharedPreferencesAsync.getInstance();
              await prefs.remove('account');
              await prefs.remove('password');
              await prefs.remove('biometric_enrolled');
              await prefs.remove('biometric_types');
              Get.offAll(LoginPage());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('歡迎登入', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Obx(() {
              return Text('帳號：${logic.account.value}');
            }),
          ],
        ),
      ),
    );
  }
}

