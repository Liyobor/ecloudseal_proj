import 'package:ecloudseal_proj/utils.dart';
import 'package:encrypt_shared_preferences/provider.dart';
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

  // secure storage keys
  static const _kAccountKey = 'account';
  static const _kPasswordKey = 'password';
  static const _kBioEnrolledKey = 'biometric_enrolled';
  static const _kBioTypesKey = 'biometric_types';

  void toggleObscure() {
    obscurePassword.value = !obscurePassword.value;
  }

  // 不強制 Email 格式，僅檢查非空（統一沿用原命名 validateEmail）
  String? validateEmail(String? value) {

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

    isLoading.value = true;
    try {

      final prefs = EncryptedSharedPreferencesAsync.getInstance();
      final savedAccount = await prefs.getString(_kAccountKey);
      final savedPassword = await prefs.getString(_kPasswordKey);

      final inputAccount = accountController.text.trim();
      final inputPassword = passwordController.text.trim();

      if (savedAccount == null || savedPassword == null) {
        await prefs.setString(_kAccountKey, inputAccount);
        await prefs.setString(_kPasswordKey, inputPassword);
        return true; // 首次：儲存後進行生物辨識
      }

      if (savedAccount != inputAccount || savedPassword != inputPassword) {
        Get.snackbar('登入失敗', '帳號或密碼不正確');
        return false;
      }

      return true; // 帳密正確，進行生物辨識
    } finally {
      isLoading.value = false;
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
          await prefs.setBool(_kBioEnrolledKey, true);
          await prefs.setString(_kBioTypesKey, types.map((e) => e.name).join(','));
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

  @override
  void onClose() {
    accountController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

