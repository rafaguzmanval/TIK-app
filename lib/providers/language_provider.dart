import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageProvider extends ChangeNotifier {
  // Spanish as default
  Locale _currentLocale = Locale('es', ''); 

  Locale get currentLocale => _currentLocale;

  void changeLanguage(Locale locale) async {
    _currentLocale = locale;
    await AppLocalizations.delegate.load(Locale(locale.languageCode, ''));
    notifyListeners();
  }
}
