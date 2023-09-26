import 'package:flutter/material.dart';
import 'package:themoviedb_example/ui/navigation/main_navigation_route_names.dart';

class MainNavigatioActions {
  const MainNavigatioActions();
  void resetNavigation(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainNavigationRouteNames.loaderWidget,
      (route) => false,
    );
  }
}
