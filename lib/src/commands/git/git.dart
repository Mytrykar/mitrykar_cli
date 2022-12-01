import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:args/command_runner.dart';
import 'package:project_cli/src/cli/cli.dart';

import 'package:project_cli/src/command_runner.dart' as c;
import 'package:path/path.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:rxdart/streams.dart';

part 'subcommands/init.dart';
part 'subcommands/pull.dart';
part 'subcommands/push.dart';
part 'subcommands/branch.dart';
part 'subcommands/watch.dart';

class GitCommand extends Command<int> {
  final Logger logger;
  GitCommand(this.logger) {
    addSubcommand(Init(logger));
    addSubcommand(Branch(logger));
    addSubcommand(Pull(logger));
    addSubcommand(Push(logger));
    addSubcommand(Watch(logger));
    argParser.addFlag("current",
        abbr: "c", help: "Shows the current remote repository.");
  }

  @override
  String get description => "worked git cli";

  @override
  String get name => "git";

  @override
  Future<int> run() async {
    if (argResults!["current"]) logger.write(currentRepo);
    return ExitCode.success.code;
  }

  String get currentRepo {
    final dir = dirname(Directory.current.path);
    if (!Directory("$dir/.git").existsSync()) return "Git not initializated";
    final config = File("$dir/.git/config");
    return config
        .readAsLinesSync()
        .firstWhere((element) => element.contains("url"));
  }
}
