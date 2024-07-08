import 'package:app_amic_dental_2024/models/route_option.dart';
import 'package:app_amic_dental_2024/screens/dashboard.dart';
import 'package:app_amic_dental_2024/screens/login.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const dashboard = "dashboard";

  static const singin = "login";

  static final routes = <RouteOption>[
    RouteOption(route: singin, name: "Login", screen: const Login()),
    RouteOption(route: dashboard, name: "dashboard", screen: const Dashboard()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll({singin: (BuildContext context) => const Dashboard()});
    for (final option in routes) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }
    return appRoutes;
  }
}
