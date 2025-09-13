import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../main.dart';
import '../utils.dart';

mixin AuthenticateMixin on GetxController {
  final _localAuth = LocalAuthentication();

  // Form state
  final formKey = GlobalKey<FormState>();

  // Controllers
  final accountController = TextEditingController();
  final passwordController = TextEditingController();


  // Failed attempts state
  final failedCount = 0.obs;

  bool get isLocked => failedCount.value >= 3;

  // secure storage keys


  @override
  void onInit() {
    super.onInit();
    _loadFailedCount();
  }

  @override
  void onClose() {
    accountController.dispose();
    passwordController.dispose();
    super.onClose();
  }


  Future<void> _loadFailedCount() async {
    try {
      final prefs = EncryptedSharedPreferencesAsync.getInstance();
      final raw = await prefs.getString(kFailedCountKey);
      failedCount.value = int.tryParse(raw ?? '0') ?? 0;
    } catch (e) {
      customDebugPrint("_loadFailedCount error : $e");
    }
  }

  Future<void> _recordFailedAttempt() async {
    try {
      final prefs = EncryptedSharedPreferencesAsync.getInstance();
      final next = failedCount.value + 1;
      await prefs.setString(kFailedCountKey, next.toString());
      failedCount.value = next;

    } catch (e) {
      customDebugPrint("_recordFailedAttempt error : $e");
    }
  }

  String? validateAccount(String? value) {

    final v = (value ?? '').trim();
    if (v.isEmpty) return '請輸入帳號（或 Email）';
    return null;
  }

  String? validatePassword(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return '請輸入密碼';
    if (v.length < 6) return '密碼至少需 6 碼';
    return null;
  }

  // 登入：
  // - 若本機尚無帳密，視為首次登入（註冊）並保存帳密。
  // - 若已有帳密，驗證輸入與保存是否一致。
  Future<bool> login() async {
    final form = formKey.currentState;
    if (form == null) return false;
    if (!form.validate()) return false;
    try {

      final prefs = EncryptedSharedPreferencesAsync.getInstance();
      final savedAccount = await prefs.getString(kAccountKey);
      final savedPassword = await prefs.getString(kPasswordKey);
      customDebugPrint('savedPassword : $savedPassword');
      final inputAccount = accountController.text.trim();
      final inputPassword = passwordController.text.trim();

      if (savedAccount == null || savedPassword == null) {
        await prefs.setString(kAccountKey, inputAccount);
        await prefs.setString(kPasswordKey, inputPassword);
        return true; // 首次：儲存後進行生物辨識
      }

      if (savedAccount != inputAccount || savedPassword != inputPassword) {
        await _recordFailedAttempt();
        final current = failedCount.value;
        final hint = current >= 3 ? '（已達 3 次，應用鎖定）' : '（已失敗 $current/3 次）';
        Get.snackbar('登入失敗', '帳號或密碼不正確 $hint');
        return false;
      }

      return true; // 帳密正確，進行生物辨識
    } catch (e){
      customDebugPrint("login error : $e");
      return false;
    }
  }

  // 生物辨識並保存結果（成功則紀錄啟用與可用類型）
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

      if (didAuthenticate) {
        try {
          final prefs = EncryptedSharedPreferences.getInstance();
          final types = await _localAuth.getAvailableBiometrics();
          await prefs.setBool(kBioEnrolledKey, true);
          await prefs.setString(kBioTypesKey, types.map((e) => e.name).join(','));
        } catch (e) {
          customDebugPrint('store biometric info error: $e');
        }
      }

      return didAuthenticate;
    } on PlatformException catch (e) {
      Get.snackbar('驗證失敗', e.message ?? '無法啟動生物辨識');
      customDebugPrint("error : ${e.message}");
      return false;
    }
  }

}