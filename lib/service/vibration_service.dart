import 'package:flaguiz/config/cc_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class VibrationService {
  VibrationService._internal();

  static final VibrationService instance = VibrationService._internal();
  bool _isVibrationOn = true;

  bool get isVibrationOn => _isVibrationOn;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isVibrationOn = prefs.getBool(CcConstants.IS_VIBTATION_ON) ?? true;
  }

  Future<void> setVibraion(bool isOn) async {
    final prefs = await SharedPreferences.getInstance();
    _isVibrationOn = isOn;
    await prefs.setBool(CcConstants.IS_VIBTATION_ON, isVibrationOn);
  }

  Future<void> light() async {
    if (!_isVibrationOn) return;
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 50);
    }
  }

  Future<void> medium() async {
    if (!_isVibrationOn) return;
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 120);
    }
  }

  Future<void> heavy() async {
    if (!_isVibrationOn) return;
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 300);
    }
  }

  Future<void> success() async {
    if (!_isVibrationOn) return;
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [0, 80, 40, 80]);
    }
  }

  Future<void> error() async {
    if (!_isVibrationOn) return;
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [0, 200, 100, 200]);
    }
  }
}
