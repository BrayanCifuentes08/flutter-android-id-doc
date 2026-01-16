import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AndroidIdNotifier extends ChangeNotifier {
  String? _androidId;

  String? get androidId => _androidId;

  Future<void> obtenerAndroidId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      _androidId = androidInfo.id; //  Captura del Android ID
    } catch (e) {
      _androidId = "No disponible";
    }
    notifyListeners();
  }
}
