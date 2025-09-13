


import 'package:flutter/foundation.dart';

void customDebugPrint(String message) {
  if (kDebugMode) {
    final now = DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    final ss = now.second.toString().padLeft(2, '0');

    debugPrint('[$hh:$mm:$ss] $message');
  }
}