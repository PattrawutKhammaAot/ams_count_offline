import 'package:bot_toast/bot_toast.dart';
import 'package:count_offline/page/loading_page.dart';
import 'package:count_offline/routes.dart';
import 'package:count_offline/services/database/sqlite_db.dart';
import 'package:count_offline/services/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'page/transaction/count_page.dart';
import 'page/export_page.dart';
import 'page/gallery_page.dart';
import 'page/import/import_page.dart';
import 'page/main_menu.dart';
import 'page/report/report_page.dart';
import 'page/setting_page.dart';

DbSqlite appDb = DbSqlite();

final easyLoading = EasyLoading.init();
final botToast = BotToastInit();
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
        builder: (context, child) {
          requestStoragePermission();
          child = easyLoading(context, child);
          child = botToast(context, child);
          return child;
        },
        initialRoute: Routes.home,
        navigatorObservers: [routeObserver, BotToastNavigatorObserver()],
        routes: Routes.getRoutes(),
      ),
    ),
  ));
}

Future<void> requestStoragePermission() async {
  try {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      if (await Permission.manageExternalStorage.request().isGranted) {
      } else {
        openAppSettings();
      }
    }
  } catch (e, s) {
    print("$e$s");
  }
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
