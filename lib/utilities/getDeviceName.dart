///Actually I haven't implemented this part of code YET. It'll be the second
/// part of my code :)

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'dart:io';

Future<String> getDeviceName() async {
  String deviceName;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name;
    }
  } on PlatformException {
    print('Failed to get platform version');
  }

  return deviceName;
}
