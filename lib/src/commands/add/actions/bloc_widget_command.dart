// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:change_case/change_case.dart';
import 'package:mason_app_project/mason_app_project.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:project_cli/src/cli/cli.dart';

void main(List<String> args) {
  BlocWidget(Logger()).run();
}

class BlocWidget extends Command<int> {
  final Logger logger;

  BlocWidget(this.logger);
  @override
  String get description => """Create a new blocWidgetBase

      !T! = CLI нічого не видаляє, зверніть на це увагу! та добре подумайте перед тим як добавляти компоненти.
      !T1 = Додавання нових маршрутів дозволено й в ручну, але рекомендовано додавати через CLI.
      """;

  @override
  String get name => "blocWidget";
  @override
  Future<int> run() async {
    if (!await FlutterCli.isFlutterProject(Directory.current.path) &&
        await Cli.isProjectCreating(Directory.current.path)) {
      logger.err(
          "the project was not created using project_cli, create the project first");
      return ExitCode.cantCreate.code;
    }

    final widget = _blocWidgetName;

    final listScreens =
        Directory("${Directory.current.path}/lib/ui/screens").list();

    if (await listScreens.isEmpty) return ExitCode.cantCreate.code;

    List<String> screens = [];

    for (var element in await listScreens.toList()) {
      screens.add(element.path.split("/").last.toPascalCase());
    }
    String parent = _parent(screens);

    logger.progress("""Create ${widget}GetWinget in $parent""");
    try {
      // TODO add screen template
      final template = MasonFlutterProject.templateBlocWidget(
          projectName: FlutterCli.projectName,
          widgetName: widget,
          parent: parent,
          path: Directory.current.path);
      Cli.create(template);
    } catch (e) {
      rethrow;
    }

    return ExitCode.success.code;
  }

  String _parent(List<String> screens) => logger
      .chooseOne("!T! = Виберіть до якого екрану додати", choices: screens);

  String get _blocWidgetName => logger.prompt("blocWidget name", hidden: true);
}
