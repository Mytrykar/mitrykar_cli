import 'dart:developer';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:project_cli/src/commands/helper.dart';
import 'package:project_cli/src/utils.dart';

class Screen extends Command<int> {
  final Logger logger;

  Screen(this.logger);
  @override
  String get description =>
      "create a new screen, a route for the screen is automatically generated";

  @override
  String get name => "screen";
  @override
  Future<int> run() async {
    if (!await Helper.checkProjectType(ProjectType.app)) {
      logger.err(
          "the project was not created using project_cli, create the project first");
    }

    final screenName = _screenName;
    final pathRoute = _pathRoute(screenName);
  }

  String _pathRoute(String screenName) {
    var newPath = "/$screenName";
    bool create = false;
    create = logger.confirm("URL = ${Helper.projectName}.com$newPath",
        defaultValue: false);
    while (!create) {
      newPath = logger.prompt("Create new URL: example: /screen/screen2/dewId:",
          defaultValue: newPath);
      create = logger.confirm("URL = ${Helper.projectName}.com$newPath",
          defaultValue: false);
    }
    return newPath;
  }

  String get _screenName {
    return logger.prompt(
        "Create name new Screen, !!!screen name must be unique!!!",
        defaultValue: null);
  }
}

class _Helper {}
