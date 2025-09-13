import 'package:encrypt_shared_preferences/provider.dart';
import 'package:get/get.dart';

class HomeLogic extends GetxController {

  var account = "unknown".obs;

  @override
  void onInit() {
    _loadAccount().then((onValue) => account(onValue));
    super.onInit();
  }

  Future<String> _loadAccount() async {
    final prefs = EncryptedSharedPreferencesAsync.getInstance();
    final acc = await prefs.getString('account');
    return acc ?? 'unknown';
  }
}
