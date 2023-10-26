import 'dart:io';

import 'package:android_id/android_id.dart';

Future<String?> getId() async {
  const _androidIdPlugin = AndroidId();

  final String? androidId = await _androidIdPlugin.getId();

  if (Platform.isAndroid) {
    return androidId;
  }
  return 'Not android device';
}
