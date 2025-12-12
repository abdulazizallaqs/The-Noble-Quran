import 'package:flutter/material.dart';
import 'package:hafzon/core/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  double _arabicFontSize = 28.0;
  final String _arabicFont = 'quran';
  SharedPreferences? _prefs;

  double get arabicFontSize => _arabicFontSize;
  String get arabicFont => _arabicFont;
  bool _isPageView = false;
  bool get isPageView => _isPageView;

  bool _isDailyReminderEnabled = false;
  bool get isDailyReminderEnabled => _isDailyReminderEnabled;
  TimeOfDay _reminderTime =
      const TimeOfDay(hour: 20, minute: 0); // Default 8 PM
  TimeOfDay get reminderTime => _reminderTime;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _arabicFontSize = (_prefs?.getInt('arabicFontSize') ?? 28).toDouble();
    _isPageView = _prefs?.getBool('isPageView') ?? false;

    _isDailyReminderEnabled =
        _prefs?.getBool('isDailyReminderEnabled') ?? false;
    int hour = _prefs?.getInt('reminderHour') ?? 20;
    int minute = _prefs?.getInt('reminderMinute') ?? 0;
    _reminderTime = TimeOfDay(hour: hour, minute: minute);

    notifyListeners();
  }

  Future<void> setArabicFontSize(double size) async {
    _arabicFontSize = size;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setInt('arabicFontSize', _arabicFontSize.toInt());
    notifyListeners();
  }

  Future<void> setPageView(bool isPage) async {
    _isPageView = isPage;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setBool('isPageView', _isPageView);
    notifyListeners();
  }

  Future<void> toggleDailyReminder(bool isEnabled) async {
    _isDailyReminderEnabled = isEnabled;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setBool('isDailyReminderEnabled', _isDailyReminderEnabled);

    if (_isDailyReminderEnabled) {
      await NotificationHelper().requestPermissions();
      await NotificationHelper().scheduleDailyNotification(_reminderTime);
    } else {
      await NotificationHelper().cancelNotification();
    }
    notifyListeners();
  }

  Future<void> setReminderTime(TimeOfDay time) async {
    _reminderTime = time;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setInt('reminderHour', time.hour);
    await _prefs?.setInt('reminderMinute', time.minute);

    if (_isDailyReminderEnabled) {
      await NotificationHelper().scheduleDailyNotification(_reminderTime);
    }
    notifyListeners();
  }

  Future<void> resetSettings() async {
    _arabicFontSize = 28.0;
    _isPageView = false;
    _isDailyReminderEnabled = false;
    _reminderTime = const TimeOfDay(hour: 20, minute: 0);

    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setInt('arabicFontSize', 28);
    await _prefs?.setBool('isPageView', false);
    await _prefs?.setBool('isDailyReminderEnabled', false);

    await NotificationHelper().cancelNotification();
    notifyListeners();
  }
}
