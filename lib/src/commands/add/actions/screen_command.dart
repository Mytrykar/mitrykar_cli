// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:project_cli/src/cli/cli.dart';

void main(List<String> args) {
  Screen(Logger()).run();
}

class Screen extends Command<int> {
  final Logger logger;

  Screen(this.logger);
  @override
  String get description =>
      """Create a new screen, a route for the screen is automatically generated:
      !T! = без приставки Screen   
       example: 
       Screen = Home 

      ROUTE = /screen2/{param1: as String}{param2: as DateTime}{param3: as int}


      !T! = Якщо Екран існує, тоді CLI спитає яке ім'я дати новому маршруту.
      !T! = без приставки Route
      example: Root User 

      !T! = CLI нічого не видаляє, зверніть на це увагу! та добре подумайте перед тим як добавляти компоненти.
      !T1 = Додавання нових маршрутів дозволено й в ручну, але рекомендовано додавати через CLI.
      """;

  @override
  String get name => "screen";
  @override
  Future<int> run() async {
    if (!await FlutterCli.isFlutterProject(Directory.current.path) &&
        await Cli.isProjectCreating(Directory.current.path)) {
      logger.err(
          "the project was not created using project_cli, create the project first");
      return ExitCode.cantCreate.code;
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
      // for (var element in Helper.routes) {
      //   if (element == "/") continue;
      //   routes.add((element + newPath));
      // }
      return logger.chooseAny("Specify parents:",
          choices: routes, defaultValues: [newPath]);
    }

    return [newPath];
  }

  String get _screenName =>
      logger.prompt("Create name new Screen, example: Sing In", hidden: true);
}
