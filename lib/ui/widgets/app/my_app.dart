import 'package:flutter/material.dart';
import 'package:themoviedb_example/ui/navigation/main_navigation_route_names.dart';
import 'package:themoviedb_example/ui/theme/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

abstract class MyAppNavigation {
  Map<String, Widget Function(BuildContext)> get routes;
  Route<Object> onGenerateRoute(RouteSettings settings);
}

class MyApp extends StatelessWidget {
  final MyAppNavigation navigation;
  const MyApp({
    Key? key,
    required this.navigation,
  }) : super(key: key);

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
      routes: navigation.routes,
      initialRoute: MainNavigationRouteNames.loaderWidget,
      onGenerateRoute: navigation.onGenerateRoute,
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
