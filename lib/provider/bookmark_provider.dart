import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider extends ChangeNotifier {
  int _bookmarkedAyah = 1;
  int _bookmarkedSurah = 1;
  SharedPreferences? _prefs;

  int get bookmarkedAyah => _bookmarkedAyah;
  int get bookmarkedSurah => _bookmarkedSurah;

  BookmarkProvider() {
    _readBookmark();
  }

  Future<void> _readBookmark() async {
    _prefs = await SharedPreferences.getInstance();
    _bookmarkedAyah = _prefs?.getInt('ayah') ?? 1;
    _bookmarkedSurah = _prefs?.getInt('surah') ?? 1;
    notifyListeners();
  }

  Future<void> saveBookmark(int surah, int ayah) async {
    _bookmarkedSurah = surah;
    _bookmarkedAyah = ayah;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setInt("surah", surah);
    await _prefs?.setInt("ayah", ayah);
    notifyListeners();
  }
}
