import 'package:count_offline/component/custom_botToast.dart';
import 'package:count_offline/extension/color_extension.dart';
import 'package:count_offline/main.dart';
import 'package:count_offline/page/dashboard_page.dart';
import 'package:count_offline/routes.dart';
import 'package:count_offline/services/database/dashboard_db.dart';
import 'package:count_offline/services/localizationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../services/theme/theme_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  bool isRefresh = false;

  @override
  void initState() {
    super.initState();
  }

  void _changeLanguage() {
    final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    if (localeNotifier.locale.languageCode == 'en') {
      localeNotifier.setLocale(Locale('th'));
    } else {
      localeNotifier.setLocale(Locale('en'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          CustomBotToast.showWarning("Can't back this screen");
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(248, 255, 255, 255),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30),
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Container(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 60.0,
                            width: 100.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Container(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          child: IconButton(
                            icon: const Icon(Icons.language),
                            onPressed: _changeLanguage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromRGBO(210, 212, 215, 1),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: SizedBox(
                          height: 210,
                          width: MediaQuery.sizeOf(context).width * 0.89,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MenuItem(
                                    imagePath: 'assets/images/import.png',
                                    text: appLocalization
                                        .localizations.menu_import,
                                    routeName: Routes.import,
                                    onPressed: () => Navigator.pushNamed(
                                            context, Routes.import)
                                        .then((v) =>
                                            DashboardDB.refreshDashboard(
                                                context)),
                                  ),
                                  MenuItem(
                                    imagePath: 'assets/images/scan.png',
                                    text: appLocalization
                                        .localizations.menu_count,
                                    routeName: '/count',
                                    onPressed: () => Navigator.pushNamed(
                                            context, Routes.select_plan)
                                        .then((v) =>
                                            DashboardDB.refreshDashboard(
                                                context)),
                                  ),
                                  MenuItem(
                                    imagePath: 'assets/images/gallery.png',
                                    text: appLocalization
                                        .localizations.menu_gallery,
                                    routeName: '/gallery',
                                    onPressed: () => Navigator.pushNamed(
                                        context, Routes.gallery),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MenuItem(
                                    imagePath: 'assets/images/report.png',
                                    text: appLocalization
                                        .localizations.menu_report,
                                    routeName: '/report',
                                    onPressed: () => Navigator.pushNamed(
                                            context, Routes.report)
                                        .then((v) =>
                                            DashboardDB.refreshDashboard(
                                                context)),
                                  ),
                                  MenuItem(
                                    imagePath: 'assets/images/export.png',
                                    text: appLocalization
                                        .localizations.menu_export,
                                    routeName: '/export',
                                    onPressed: () => Navigator.pushNamed(
                                        context, Routes.export),
                                  ),
                                  MenuItem(
                                    imagePath: 'assets/images/settings.png',
                                    text: appLocalization
                                        .localizations.menu_setting,
                                    routeName: '/setting',
                                    onPressed: () => Navigator.pushNamed(
                                        context, Routes.setting),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade800,
              highlightColor: Colors.grey.shade100,
              period: const Duration(milliseconds: 2500),
              child: Row(
                children: [
                  Expanded(child: Divider()),
                  SizedBox(width: 10),
                  Text(
                    LocalizationService().localizations.overview,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(60, 60, 60, 0.6),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(child: Divider()),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: DashBoardPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String imagePath;
  final String text;
  final String routeName;
  final Function() onPressed;

  const MenuItem({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.routeName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 50.0,
              width: 50.0,
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(60, 60, 60, 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
