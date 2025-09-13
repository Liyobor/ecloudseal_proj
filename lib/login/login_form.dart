import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key, required this.onSubmit});

  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<LoginLogic>();

    return Form(
      key: logic.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: logic.accountController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: '帳號',
              hintText: 'username 或 email',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: logic.validateEmail,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          Obx(
            () => TextFormField(
              controller: logic.passwordController,
              obscureText: logic.obscurePassword.value,
              decoration: InputDecoration(
                labelText: '密碼',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: logic.toggleObscure,
                  icon: Icon(
                    logic.obscurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              validator: logic.validatePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(onSubmit),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: 導向忘記密碼頁
              },
              child: const Text('忘記密碼？'),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => FilledButton(
              onPressed: Get.find<LoginLogic>().isLoading.value
                  ? null
                  : () => _submit(onSubmit),
              child: Get.find<LoginLogic>().isLoading.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('登入'),
            ),
          ),
        ],
      ),
    );
  }

  void _submit(Future<void> Function() onSubmit) {
    onSubmit();
  }
}

