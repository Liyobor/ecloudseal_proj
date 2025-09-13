import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginLogic extends GetxController {
  // Form state
  final formKey = GlobalKey<FormState>();

  // Controllers
  final accountController = TextEditingController();
  final passwordController = TextEditingController();

  // UI state
  final isLoading = false.obs;
  final obscurePassword = true.obs;

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

  @override
  void onClose() {
    accountController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
