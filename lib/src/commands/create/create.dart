import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mitrykar_cli/mitrykar_cli.dart';
import 'package:mitrykar_cli/src/cli/cli.dart';
import 'package:path/path.dart';

part 'subcommands/app.dart';
part 'subcommands/server.dart';
part 'subcommands/website.dart';

const create = "create";

enum ProjectType { app, server, website }

class CreateCommand extends Command<int> {
  final Logger logger;
  CreateCommand({required this.logger}) {
    addSubcommand(CreateApp(logger));
    addSubcommand(CreateDartServer(logger));
    addSubcommand(CreateStaticWebSite(logger));
    argParser
      ..addFlag(
        'git-init',
        abbr: 'g',
        help: 'Initialize the Git repository.',
        defaultsTo: null,
      )
      ..addOption(
        'remote',
        abbr: 'r',
        help:
            'A link to your git repository. example :https://github.com/you_profile/you_repository.git',
        defaultsTo: null,
      );
  }
  @override
  String get description => "Create project";

  @override
  String get name => "create";
  @override
  String get invocation => '$executableName $name <project>';

  // @override
  // Future<int> run() async {}
}
