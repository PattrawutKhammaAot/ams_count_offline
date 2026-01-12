import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th')
  ];

  /// No description provided for @menu_import.
  ///
  /// In en, this message translates to:
  /// **'Import File'**
  String get menu_import;

  /// No description provided for @menu_export.
  ///
  /// In en, this message translates to:
  /// **'Export File'**
  String get menu_export;

  /// No description provided for @menu_count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get menu_count;

  /// No description provided for @menu_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get menu_gallery;

  /// No description provided for @menu_setting.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menu_setting;

  /// No description provided for @menu_report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get menu_report;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @ov_plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get ov_plan;

  /// No description provided for @ov_images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get ov_images;

  /// No description provided for @ov_counted.
  ///
  /// In en, this message translates to:
  /// **'Checked'**
  String get ov_counted;

  /// No description provided for @ov_not_counted.
  ///
  /// In en, this message translates to:
  /// **'Uncheck'**
  String get ov_not_counted;

  /// No description provided for @import_title.
  ///
  /// In en, this message translates to:
  /// **'Import File'**
  String get import_title;

  /// No description provided for @import_btn_clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get import_btn_clearAll;

  /// No description provided for @import_btn_import.
  ///
  /// In en, this message translates to:
  /// **'Import File'**
  String get import_btn_import;

  /// No description provided for @import_alert_title.
  ///
  /// In en, this message translates to:
  /// **'Alert!'**
  String get import_alert_title;

  /// No description provided for @import_alert_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all data?'**
  String get import_alert_content;

  /// No description provided for @import_btn_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get import_btn_delete;

  /// No description provided for @import_btn_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get import_btn_cancel;

  /// No description provided for @report_title.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report_title;

  /// No description provided for @report_dropdown.
  ///
  /// In en, this message translates to:
  /// **'Select Plan'**
  String get report_dropdown;

  /// No description provided for @report_txt_uncheck.
  ///
  /// In en, this message translates to:
  /// **'Uncheck'**
  String get report_txt_uncheck;

  /// No description provided for @report_txt_check.
  ///
  /// In en, this message translates to:
  /// **'Checked'**
  String get report_txt_check;

  /// No description provided for @report_btn_view_uncheck.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get report_btn_view_uncheck;

  /// No description provided for @report_btn_view_check.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get report_btn_view_check;

  /// No description provided for @export_title.
  ///
  /// In en, this message translates to:
  /// **'Export File'**
  String get export_title;

  /// No description provided for @export_downdown.
  ///
  /// In en, this message translates to:
  /// **'Please select a file to export'**
  String get export_downdown;

  /// No description provided for @export_btn_export.
  ///
  /// In en, this message translates to:
  /// **'Export File to Excel'**
  String get export_btn_export;

  /// No description provided for @listplan_title.
  ///
  /// In en, this message translates to:
  /// **'Plan List'**
  String get listplan_title;

  /// No description provided for @listplan_uncheked.
  ///
  /// In en, this message translates to:
  /// **'Uncheck'**
  String get listplan_uncheked;

  /// No description provided for @listplan_checked.
  ///
  /// In en, this message translates to:
  /// **'Checked'**
  String get listplan_checked;

  /// No description provided for @listplan_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get listplan_total;

  /// No description provided for @listplan_plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get listplan_plan;

  /// No description provided for @listplan_created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get listplan_created;

  /// No description provided for @setting_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting_title;

  /// No description provided for @setting_btn_clear_data.
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get setting_btn_clear_data;

  /// No description provided for @setting_alert_clear_data_title.
  ///
  /// In en, this message translates to:
  /// **'Alert!'**
  String get setting_alert_clear_data_title;

  /// No description provided for @setting_alert_clear_data_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all data?'**
  String get setting_alert_clear_data_content;

  /// No description provided for @setting_btn_clear_image.
  ///
  /// In en, this message translates to:
  /// **'Clear Images'**
  String get setting_btn_clear_image;

  /// No description provided for @setting_alert_clear_image_title.
  ///
  /// In en, this message translates to:
  /// **'Alert!'**
  String get setting_alert_clear_image_title;

  /// No description provided for @setting_alert_clear_image_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all images?'**
  String get setting_alert_clear_image_content;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get no_data;

  /// No description provided for @no_image.
  ///
  /// In en, this message translates to:
  /// **'No image'**
  String get no_image;

  /// No description provided for @no_plan.
  ///
  /// In en, this message translates to:
  /// **'No plan'**
  String get no_plan;

  /// No description provided for @no_data_found.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get no_data_found;

  /// No description provided for @import_loading.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get import_loading;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @update_success.
  ///
  /// In en, this message translates to:
  /// **'Update successful'**
  String get update_success;

  /// No description provided for @update_image_success.
  ///
  /// In en, this message translates to:
  /// **'Update image successful'**
  String get update_image_success;

  /// No description provided for @upload_image_success.
  ///
  /// In en, this message translates to:
  /// **'Upload image successful'**
  String get upload_image_success;

  /// No description provided for @export_success.
  ///
  /// In en, this message translates to:
  /// **'Export successful'**
  String get export_success;

  /// No description provided for @export_loading.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get export_loading;

  /// No description provided for @export_to.
  ///
  /// In en, this message translates to:
  /// **'Export to'**
  String get export_to;

  /// No description provided for @delete_all_Data.
  ///
  /// In en, this message translates to:
  /// **'All data have been deleted'**
  String get delete_all_Data;

  /// No description provided for @failed_to_delete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete'**
  String get failed_to_delete;

  /// No description provided for @delete_all_images.
  ///
  /// In en, this message translates to:
  /// **'All images have been deleted'**
  String get delete_all_images;

  /// No description provided for @warning_count_asset.
  ///
  /// In en, this message translates to:
  /// **'Warning!'**
  String get warning_count_asset;

  /// No description provided for @warning_count_asset_already_count.
  ///
  /// In en, this message translates to:
  /// **'This asset has already been counted. Do you want to count it again?'**
  String get warning_count_asset_already_count;

  /// No description provided for @warning_count_department_not_match.
  ///
  /// In en, this message translates to:
  /// **'The counted department does not match the plan data'**
  String get warning_count_department_not_match;

  /// No description provided for @warning_count_location_not_match.
  ///
  /// In en, this message translates to:
  /// **'The counted location does not match the plan data'**
  String get warning_count_location_not_match;

  /// No description provided for @warning_count_location_and_department_not_match.
  ///
  /// In en, this message translates to:
  /// **'The counted department and location do not match the plan data'**
  String get warning_count_location_and_department_not_match;

  /// No description provided for @warning_count_asset_not_in_plan.
  ///
  /// In en, this message translates to:
  /// **'This asset is not in the plan. Do you want to count it?'**
  String get warning_count_asset_not_in_plan;

  /// No description provided for @btn_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get btn_ok;

  /// No description provided for @btn_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get btn_save;

  /// No description provided for @btn_refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get btn_refresh;

  /// No description provided for @btn_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get btn_camera;

  /// No description provided for @warning_title.
  ///
  /// In en, this message translates to:
  /// **'Warning!'**
  String get warning_title;

  /// No description provided for @warning_content.
  ///
  /// In en, this message translates to:
  /// **'Please select the location or department to be counted'**
  String get warning_content;

  /// No description provided for @warning_uncheck_save.
  ///
  /// In en, this message translates to:
  /// **'Cannot save because the asset has not been counted'**
  String get warning_uncheck_save;

  /// No description provided for @warning_uncheck_photo.
  ///
  /// In en, this message translates to:
  /// **'Cannot Upload Image because the asset has not been counted'**
  String get warning_uncheck_photo;

  /// No description provided for @settings_path.
  ///
  /// In en, this message translates to:
  /// **'Config Path Images'**
  String get settings_path;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'th': return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
