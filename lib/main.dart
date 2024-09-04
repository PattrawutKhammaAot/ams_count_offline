import 'package:bot_toast/bot_toast.dart';
import 'package:count_offline/page/dashboard_page.dart';
import 'package:count_offline/page/loading_page.dart';
import 'package:count_offline/routes.dart';
import 'package:count_offline/services/database/sqlite_db.dart';
import 'package:count_offline/services/localizationService.dart';
import 'package:count_offline/services/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

DbSqlite appDb = DbSqlite();

final easyLoading = EasyLoading.init();
final botToast = BotToastInit();
final appLocalization = LocalizationService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await appDb.initializeDatabase();
  final RouteObserver<PageRoute> routeObserver = CustomRouteObserver();
  configLoading();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<LocaleNotifier>(create: (_) => LocaleNotifier()),
        ChangeNotifierProvider<DashBoardNotifier>(
            create: (_) => DashBoardNotifier()),
      ],
      child: MyApp(routeObserver: routeObserver),
    ),
  );
}

class MyApp extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver;

  MyApp({required this.routeObserver});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleNotifier>(
      builder: (context, localeNotifier, _) {
        return MaterialApp(
          builder: (context, child) {
            appLocalization.setLocalizations(context);

            requestStoragePermission();

            child = easyLoading(context, child);
            child = botToast(context, child);
            return child;
          },
          initialRoute: Routes.home,
          navigatorObservers: [routeObserver, BotToastNavigatorObserver()],
          routes: Routes.getRoutes(),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: localeNotifier.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: Provider.of<ThemeNotifier>(context).getTheme(),
        );
      },
    );
  }
}

Future<void> requestStoragePermission() async {
  try {
    // Request both camera and manage external storage permissions at the same time
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.manageExternalStorage,
    ].request();

    // Check the status of manage external storage permission
    if (!statuses[Permission.manageExternalStorage]!.isGranted) {
      // If not granted, open app settings
      openAppSettings();
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

class LocaleNotifier extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
