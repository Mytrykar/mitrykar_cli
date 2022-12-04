library app_router;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:project_app/app/utils/logger.dart';
import 'package:project_app/ui/screens/home/performance/home_view.dart';
import 'package:project_app/ui/widgets/dumb/error_widget.dart' as e;

part 'observer.dart';
part 'router.g.dart';
part 'routes/home_route.dart';
part 'routes/example_route.dart';

class AppRouter {
  /// use this in [MaterialApp.router]
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    routes: $appRoutes,
    observers: _observers,
    errorBuilder: (context, state) => const Scaffold(body: e.ErrorWidget()),
  );

  static List<NavigatorObserver>? get _observers {
    if (kDebugMode) return [_DebugObserver()];
    return null;
  }
}
// Gen_project_cli: /example
@TypedGoRoute<ExampleRoute>(
  path: '/example',
  routes: <TypedGoRoute<GoRouteData>>[
// Gen_project_cli: /example/example2/:tag
    TypedGoRoute<ExampleRoute2>(
      path: 'example2/:tag',
    ),
  ],
)