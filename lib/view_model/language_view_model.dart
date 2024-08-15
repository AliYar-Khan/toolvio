import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageViewModel extends ChangeNotifier {
  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  void changeLocale(String lang) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (lang == 'en') {
      sp.setString("locale", "en");
      _appLocale = const Locale("en");
    } else {
      sp.setString("locale", "de");
      _appLocale = const Locale("de");
    }
    notifyListeners();
  }
}
