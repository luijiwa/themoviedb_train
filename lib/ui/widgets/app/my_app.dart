import 'package:flutter/material.dart';
import 'package:themoviedb_example/ui/navigation/main_navigation.dart';
import 'package:themoviedb_example/ui/theme/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  // final MyAppModel model;
  static final mainNavigation = MainNavigation();
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainDarkBlue,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      routes: mainNavigation.routes,
      initialRoute: MainNavigationRouteNames.loaderWidget,
      onGenerateRoute: mainNavigation.onGenerateRoute,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'), // Russian
        Locale('en'), // English
      ],
    );
  }
}
