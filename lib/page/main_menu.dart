import 'package:count_offline/component/charts/barchart_trans.dart';
import 'package:count_offline/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../services/theme/theme_manager.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: theme.getTheme(),
        home: Scaffold(
            // appBar: AppBar(title: Text('app.title').tr(), actions: <Widget>[
            //   IconButton(
            //     icon: const Icon(
            //       Icons.language,
            //     ),
            //     onPressed: () => setState(() {
            //       if (context.locale.languageCode == 'en') {
            //         context.setLocale(Locale('th'));
            //       } else {
            //         context.setLocale(Locale('en'));
            //       }
            //     }),
            //   ),
            //   IconButton(
            //     icon: const Icon(
            //       Icons.sunny,
            //     ),
            //     onPressed: () {
            //       if (theme.getTheme() == theme.darkTheme) {
            //         theme.setLightMode();
            //       } else {
            //         theme.setDarkMode();
            //       }
            //     },
            //   )
            // ]),
            backgroundColor: Color.fromARGB(248, 255, 255, 255),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  height: 350,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //const Padding(padding: EdgeInsets.only(left: 20)),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Container(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  child: Image.asset('assets/images/logo.png',
                                      height: 60.0,
                                      width: 100.0,
                                      fit: BoxFit.contain),
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            // const Text(
                            //   'app.name',
                            //   style: TextStyle(
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 20),
                            // ).tr(),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Container(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.language,
                                    ),
                                    onPressed: () => setState(() {
                                      if (context.locale.languageCode == 'en') {
                                        context.setLocale(Locale('th'));
                                      } else {
                                        context.setLocale(Locale('en'));
                                      }
                                    }),
                                  ),
                                )),
                          ]),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Color.fromRGBO(210, 212, 215, 1)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
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
                                        text: 'app.import',
                                        routeName: Routes.import,
                                        onPressed: () => Navigator.pushNamed(
                                            context, Routes.import),
                                      ),
                                      MenuItem(
                                        imagePath: 'assets/images/scan.png',
                                        text: 'app.count',
                                        routeName: '/count',
                                        onPressed: () => Navigator.pushNamed(
                                            context, Routes.select_plan),
                                      ),
                                      MenuItem(
                                        imagePath: 'assets/images/gallery.png',
                                        text: 'app.gallery',
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
                                        text: 'app.report',
                                        routeName: '/report',
                                        onPressed: () => Navigator.pushNamed(
                                            context, Routes.report),
                                      ),
                                      MenuItem(
                                        imagePath: 'assets/images/export.png',
                                        text: 'app.export',
                                        routeName: '/export',
                                        onPressed: () => Navigator.pushNamed(
                                            context, Routes.export),
                                      ),
                                      MenuItem(
                                        imagePath: 'assets/images/settings.png',
                                        text: 'app.setting',
                                        routeName: '/setting',
                                        onPressed: () => Navigator.pushNamed(
                                            context, Routes.setting),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ), //Row TOP Menu
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 520,
                  child: BarChartSample1(),
                ),
              ],
            ))),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String imagePath;
  final String text;
  final String routeName;
  final Function() onPressed;

  const MenuItem(
      {Key? key,
      required this.imagePath,
      required this.text,
      required this.routeName,
      required this.onPressed})
      : super(key: key);

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
            Text(text,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(60, 60, 60, 0.6)))
                .tr(),
          ],
        ),
      ),
    );
  }
}
