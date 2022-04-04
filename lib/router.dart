import 'package:ecodate/entities/segment.dart';
import 'package:ecodate/pages/scenario_runner/game_page.dart';
import 'package:flutter/material.dart';

class FlagState {}

class EcodateRouter {
  static Route buildRoute(BuildContext context, RouteSettings settings) {
    switch (settings.name) {
      case '/game':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (BuildContext context, _, __) {
            final SceneInfo sceneInfo = settings.arguments as SceneInfo;
            return GamePage(sceneInfo: sceneInfo);
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation, __, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      default:
        throw Exception('Route `${settings.name}` not found');
    }
  }
}
