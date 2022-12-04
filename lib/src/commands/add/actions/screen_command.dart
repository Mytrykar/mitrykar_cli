import 'dart:developer';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
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
    // if (!await Helper.isFlutterApp) {
    //   logger.err(
    //       "the project was not created using project_cli, create the project first");
    // }

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
      // for (var element in Helper.routes) {
      //   if (element == "/") continue;
      //   routes.add((element + newPath));
      // }
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
