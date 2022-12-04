import 'dart:developer';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:change_case/change_case.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:project_cli/src/commands/helper.dart';
import 'package:project_cli/src/utils.dart';

void main(List<String> args) {
  Screen(Logger()).run();
}

class Screen extends Command<int> {
  final Logger logger;

  Screen(this.logger);
  @override
  String get description =>
      "Create a new screen, a route for the screen is automatically generated, : example: Screen = Home ROUTE = /screen2/dewId";

  @override
  String get name => "screen";
  @override
  Future<int> run() async {
    if (!await Helper.isFlutterApp) {
      logger.err(
          "the project was not created using project_cli, create the project first");
    }

    final screenName = _screenName;
    final pathRoute = _pathRoute(screenName);
    logger.progress(
        """Create ${screenName.replaceAll(RegExp(r' '), "")}Screen and routes:
    ${pathRoute.join("""
""")}""");
    return ExitCode.success.code;
  }

  List<String> _pathRoute(String screenName) {
    var newPath = "/${screenName.replaceAll(RegExp(r' '), "-").toLowerCase()}";
    newPath = logger.prompt("""current ROUTE = $newPath.
Replase ROUTE?: example: /screen2/:params as String or /screen2:
""", defaultValue: newPath);

    bool isNestedRoute =
        logger.confirm("""ROUTE = $newPath. This route has a parent?
        """, defaultValue: false);
    if (isNestedRoute) {
      final List<String> routes = [newPath];
      for (var element in Helper.routes) {
        if (element == "/") continue;
        routes.add((element + newPath));
      }
      return logger.chooseAny("Specify parents:",
          choices: routes, defaultValues: [newPath]);
    }

    return [newPath];
  }

  String get _screenName {
    return logger.prompt(
        "Create name new Screen, !!!screen name must be unique!!!, example: Sing In",
        defaultValue: null);
  }
}

class ScreenParameters {
  final List<String> routes;
  final String screenName;
  final File routerFile;
  final Directory? screensDir;
  final Directory routesDir;
  final String projectName;

  ScreenParameters(this.projectName,
      {required this.routes,
      required this.routerFile,
      required this.screenName,
      this.screensDir,
      required this.routesDir});

  factory ScreenParameters.named(List<String> routes, String screenName) {
    final _d = Directory.current.path;
    final File routerFile = File("$_d/lib/app/router/router.dart");
    Directory? screensDir;
    final Directory routesDir = Directory("$_d/lib/app/router/routes");

    if (!ScreenParameters.exist(screenName)) {
      screensDir = Directory("$_d/lib/ui/screens");
    }
    if (!routerFile.existsSync() || !routesDir.existsSync()) {
      throw "Creation is impossible";
    }
    return ScreenParameters(Helper.projectName,
        routerFile: routerFile,
        routes: routes,
        routesDir: routesDir,
        screenName: screenName,
        screensDir: screensDir);
  }

  static bool exist(String screenName) {
    final _d = Directory.current.path;
    return File("$_d/lib/ui/screens/${screenName.toSnakeCase()}").existsSync();
  }
}

abstract class $Gen {
  Future<void> run();
}

class $GenNewScreen implements $Gen {
  final ScreenParameters genParameters;

  $GenNewScreen(this.genParameters);

  @override
  Future<void> run() async {
    if (genParameters.screensDir == null) return;
    throw UnimplementedError();
  }
}
