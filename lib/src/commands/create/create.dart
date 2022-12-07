// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_app_project/mason_app_project.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:project_cli/project_cli.dart';
import 'package:project_cli/src/cli/cli.dart';
import 'package:project_cli/src/utils.dart';
import 'package:path/path.dart';

part 'subcommands/app.dart';
part 'subcommands/server.dart';
part 'subcommands/website.dart';

const create = "create";

class CreateCommand extends Command<int> {
  final Logger logger;
  CreateCommand({required this.logger}) {
    addSubcommand(CreateApp(logger));
    addSubcommand(CreateDartServer(logger));
    addSubcommand(CreateStaticWebSite(logger));
  }
  @override
  String get description => "Create project";

  @override
  String get name => "create";
  @override
  String get invocation => '$executableName $name <project>';

  @override
  Future<int> run() async => ExitCode.success.code;
}
