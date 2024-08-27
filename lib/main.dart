import 'package:count_offline/page/loading_page.dart';
import 'package:count_offline/routes.dart';
import 'package:count_offline/services/database/sqlite_db.dart';
import 'package:count_offline/services/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'page/transaction/count_page.dart';
import 'page/export_page.dart';
import 'page/gallery_page.dart';
import 'page/import/import_page.dart';
import 'page/main_menu.dart';
import 'page/report_page.dart';
import 'page/setting_page.dart';

String uncheck = 'Uncheck';
String checked = 'Check';
String status_open = 'Open';
String status_close = 'Close';
String status_count = 'Counting';

DbSqlite appDb = DbSqlite();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await appDb.initializeDatabase();
  final RouteObserver<PageRoute> routeObserver = CustomRouteObserver();
  configLoading();
  return runApp(EasyLocalization(
    supportedLocales: [Locale('en'), Locale('th')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: MaterialApp(
        builder: EasyLoading.init(),
        initialRoute: Routes.home,
        navigatorObservers: [routeObserver],
        routes: Routes.getRoutes(),
      ),
    ),
  ));
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
