import 'package:ecloudseal_proj/mixin_on_getx_controller/authenticate_mixin.dart';
import 'package:get/get.dart';


class LoginLogic extends GetxController with AuthenticateMixin {


  // UI state
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  void toggleObscure() {
    obscurePassword.value = !obscurePassword.value;
  }

  @override
  Future<bool> login() async {
    isLoading(true);
    final res = await super.login();
    isLoading(false);
    return res;
  }
}
