import 'package:count_offline/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

//gen ภาษา ใช้ command flutter gen-l10n
class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();

  late AppLocalizations _localizations;

  factory LocalizationService() {
    return _instance;
  }

  LocalizationService._internal();

  void setLocalizations(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
  }

  AppLocalizations get localizations => _localizations;
}
