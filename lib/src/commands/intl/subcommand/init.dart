import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:project_cli/src/cli/cli.dart';

class InitLocalozationsCommand extends Command<int> {
  final Logger logger;

  InitLocalozationsCommand(this.logger);
  @override
  String get description => "Add localization";

  @override
  String get name => "init";

  @override
  Future<int> run() async {
    final locale = _l10n;
    // final locale = "en";
    logger.info(""""
Generated  intl""");
    await IntlCli(Directory.current.path, logger).init(locale);
    return ExitCode.success.code;
  }

  String get _l10n {
    return logger.prompt("Enter basic locale:", defaultValue: "en");
  }
}
