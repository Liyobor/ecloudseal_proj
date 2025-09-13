import 'package:ecloudseal_proj/login/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final SplashLogic logic = Get.put(SplashLogic());



  @override
  StatelessElement createElement() {
    // 將頁面導向 LoginPage
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.off(()=>LoginPage());
    });
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
