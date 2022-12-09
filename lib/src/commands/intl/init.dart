import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:project_cli/src/commands/intl/subcommand/init.dart';

class LocalozationsCommand extends Command<int> {
  final Logger logger;
  LocalozationsCommand(this.logger) {
    addSubcommand(InitLocalozationsCommand(logger));
  }
  @override
  String get description => "localization in your app";

  @override
  String get name => "gen-l10n";

  @override
  Future<int> run() async {
    return ExitCode.software.code;
  }
}
