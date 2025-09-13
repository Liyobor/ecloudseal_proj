import 'package:ecloudseal_proj/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class LoginLogic extends GetxController {
  // Form state
  final formKey = GlobalKey<FormState>();

  // Controllers
  final accountController = TextEditingController();
  final passwordController = TextEditingController();

  // UI state
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final _localAuth = LocalAuthentication();

  void toggleObscure() {
    obscurePassword.value = !obscurePassword.value;
  }

  String? validateEmail(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return '請輸入帳號（或 Email）';
    // 不強制 Email 格式；允許一般帳號或 Email。
    return null;
  }

  String? validatePassword(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return '請輸入密碼';
    if (v.length < 6) return '密碼至少需 6 碼';
    return null;
  }

  Future<bool> login() async {
    final form = formKey.currentState;
    if (form == null) return false;
    if (!form.validate()) return false;

    isLoading.value = true;
    try {
      // 此專案不包含後端功能,直接回傳true讓用戶登入即可
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> authenticateBiometrics() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!supported || !canCheck) {
        Get.snackbar('無法生物辨識', '此裝置未啟用或不支援生物辨識');
        return false;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: '請以 Face ID 或指紋確認身份',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      Get.snackbar('驗證失敗', e.message ?? '無法啟動生物辨識');
      customDebugPrint("error : ${e.message}");
      return false;
    }
  }

  @override
  void onClose() {
    accountController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
