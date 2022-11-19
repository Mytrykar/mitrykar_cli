import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mitrykar_cli/src/cli/cli.dart';
import 'package:path/path.dart';
import 'package:mason_logger/mason_logger.dart';

part 'subcommands/init.dart';
part 'subcommands/pull.dart';
part 'subcommands/push.dart';
part 'subcommands/branch.dart';

class GitCommand extends Command<int> {
  final Logger logger;
  GitCommand(this.logger) {
    addSubcommand(Init(logger));
    addSubcommand(Branch(logger));
    addSubcommand(Pull(logger));
    addSubcommand(Push(logger));
  }

  @override
  String get description => "worked git cli";

  @override
  String get name => "git";

  // @override
  // Future<int> run() async {
  //   final git = _git;
  //   if(!git) {
  //     logger.info();
  //     return }
  //   final remote = _remote;

  // }

}
