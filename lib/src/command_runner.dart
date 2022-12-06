// ignore_for_file: depend_on_referenced_packages

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:project_cli/src/utils.dart';
import 'package:project_cli/src/version.dart';
import 'package:pub_updater/pub_updater.dart';

import 'commands/create/create.dart';
import 'commands/git/git.dart';

const executableName = 'project_cli';
const packageName = 'project_cli';
const description =
    """Створи автоматизований проект за допомогою project Command Line Interface.
      Команду add використовуйте в директорії де ви виконали create_app!!!
      cd <directory add>
      project_cli add list
      project_cli add stream_view
    """;

class CliRunner extends CommandRunner<int> {
  CliRunner({
    Logger? logger,
    PubUpdater? pubUpdater,
  })  : _logger = logger ?? Logger(),
        _pubUpdater = pubUpdater ?? PubUpdater(),
        super(executableName, description) {
    argParser
      ..addFlag(
        'version',
        abbr: 'v',
        negatable: false,
        help: 'Поточна версія CLI',
      )
      ..addFlag(
        'verbose',
        help: 'Логування з шумом, включаючи всі виконані команди оболонки.',
      );
    addCommand(GitCommand(_logger));
    addCommand(CreateCommand(logger: _logger));
    // addCommand(UpdateCommand(logger: _logger, pubUpdater: _pubUpdater));
    // addCommand(ProjectCommand().addSubcommand(ProjectUpgradeSubcommand()));
  }

  final Logger _logger;
  final PubUpdater _pubUpdater;

  @override
  Future<int> run(Iterable<String> args) async {
    Status.init(_logger);
    try {
      final topLevelResults = parse(args);
      if (topLevelResults['verbose'] == true) {
        _logger.level = Level.verbose;
      }
      return await runCommand(topLevelResults) ?? ExitCode.success.code;
    } on FormatException catch (e, stackTrace) {
      _logger
        ..err(e.message)
        ..err('$stackTrace')
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on UsageException catch (e) {
      _logger
        ..err(e.message)
        ..info('')
        ..info(e.usage);
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    _logger
      ..detail('Argument information:')
      ..detail('  Top level options:');
    for (final option in topLevelResults.options) {
      if (topLevelResults.wasParsed(option)) {
        _logger.detail('  - $option: ${topLevelResults[option]}');
      }
    }
    if (topLevelResults.command != null) {
      final commandResult = topLevelResults.command!;
      _logger
        ..detail('  Command: ${commandResult.name}')
        ..detail('    Command options:');
      for (final option in commandResult.options) {
        if (commandResult.wasParsed(option)) {
          _logger.detail('    - $option: ${commandResult[option]}');
        }
      }
    }

    final int? exitCode;
    if (topLevelResults['version'] == true) {
      _logger.info(packageVersion);
      exitCode = ExitCode.success.code;
    } else {
      exitCode = await super.runCommand(topLevelResults);
    }
    await _checkForUpdates();
    return exitCode;
  }

  Future<void> _checkForUpdates() async {
    try {
      final latestVersion = await _pubUpdater.getLatestVersion(packageName);
      final isUpToDate = packageVersion == latestVersion;
      if (!isUpToDate) {
        _logger
          ..info('')
          ..info(
            '''
${lightYellow.wrap('Update available!')} ${lightCyan.wrap(packageVersion)} \u2192 ${lightCyan.wrap(latestVersion)}
Run ${lightCyan.wrap('project_cli update')} to update''',
          );
      }
    } catch (_) {}
  }
}
