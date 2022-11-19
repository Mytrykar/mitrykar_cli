part of 'cli.dart';

/// Thrown when `flutter packages get` or `flutter pub get`
/// is executed without a `pubspec.yaml`.
class PubspecNotFound implements Exception {}

class FlutterCli {
  static Future<void> create(Logger logger,
      {required ProjectType projectType,
      required String projectName,
      required String path}) async {
    assert(projectType == ProjectType.app);
    logger.progress("Create Flutter App");
    try {
      await Cli.run('flutter', ['create', path, "--project-name", projectName],
          workingDirectory: path);
      logger.progress(
          '''Architecture template successfully created MVVM + bloc''');
    } catch (e) {
      logger.err("An error occurred while creating Flutter App");
    }
  }

  /// Determine whether flutter is installed.
  static Future<bool> installed() async {
    try {
      await Cli.run('flutter', ['--version']);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Install dart dependencies (`flutter pub get`).
  static Future<void> pubGet({
    String cwd = '.',
    bool recursive = false,
  }) async {
    await _runCommand(
      cmd: (cwd) => Cli.run(
        'flutter',
        ['pub', 'get'],
        workingDirectory: cwd,
      ),
      cwd: cwd,
      recursive: recursive,
    );
  }

  /// run generators (`flutter pub run build_runner build --delete-conflicting-outputs`).
  static Future<void> runBuildRunner({
    String cwd = '.',
    bool recursive = false,
  }) async {
    await _runCommand(
      cmd: (cwd) => Cli.start(
        'flutter',
        ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
        workingDirectory: cwd,
      ),
      cwd: cwd,
      recursive: recursive,
    );
  }

  /// generate localized strings (`flutter pub global run intl_utils:generate`).
  static Future<void> runIntlUtils({
    String cwd = '.',
    bool recursive = false,
    required Logger logger,
  }) async {
    final check = logger.progress('Checking intl_utils');
    final res = await Cli.run('flutter', ['pub', 'global', 'list'],
        workingDirectory: cwd);
    if (res.stdout.toString().contains('intl_utils')) {
      check.complete('intl_utils is already activated');
      await _generate(logger, cwd);
    } else {
      check.complete('intl_utils not yet activated.');
      final activate = logger.progress('Activating intl_utils');
      await Cli.run('flutter', ['pub', 'global', 'activate', 'intl_utils']);
      activate.complete('Activated intl_utils');
      await _generate(logger, cwd);
    }
  }

  static bool isFlutterProject() {
    final currentDirectory = Directory.current;
    final pubspecFile =
        File(p.join(currentDirectory.absolute.path, 'pubspec.yaml'));
    return pubspecFile.existsSync();
  }

  static String packageName() {
    final currentDirectory = Directory.current;
    if (isFlutterProject()) {
      final pubspecFile =
          File(p.join(currentDirectory.absolute.path, 'pubspec.yaml'));
      final yaml = Pubspec.parse(pubspecFile.readAsStringSync());
      return yaml.name;
    } else {
      throw PubspecNotFound();
    }
  }

  static String projectType() {
    final currentDirectory = Directory.current;
    if (isFlutterProject()) {
      final cliFile = File(p.join(currentDirectory.absolute.path, '.cli'));
      if (cliFile.existsSync()) {
        return cliFile
            .readAsLinesSync()
            .where((element) => !element.startsWith('//'))
            .firstWhere((element) => element.startsWith('project_type:'))
            .split(' ')
            .last;
      }
      throw FileSystemException();
    } else {
      throw PubspecNotFound();
    }
  }

  /// Run a command on directories with a `pubspec.yaml`.
  static Future<List<T>> _runCommand<T>({
    required Future<T> Function(String cwd) cmd,
    required String cwd,
    required bool recursive,
  }) async {
    if (!recursive) {
      final pubspec = File(p.join(cwd, 'pubspec.yaml'));
      if (!pubspec.existsSync()) throw PubspecNotFound();

      return [await cmd(cwd)];
    }

    final processes = Cli.runWhere<T>(
      run: (entity) => cmd(entity.parent.path),
      where: _isPubspec,
      cwd: cwd,
    );

    if (processes.isEmpty) throw PubspecNotFound();

    final results = <T>[];
    for (final process in processes) {
      results.add(await process);
    }
    return results;
  }

  static Future<void> _generate(Logger logger, String cwd) async {
    final generate = logger.progress(
        'Running ${lightGreen.wrap('flutter pub global run intl_utils:generate')}');
    await Cli.run(
      'flutter',
      ['pub', 'global', 'run', 'intl_utils:generate'],
      workingDirectory: cwd,
    );
    generate.complete('Successfully generated localized strings');
  }

  static copyEnvs(Logger logger, String path) async {
    final isWindows = Platform.isWindows;
    var cmd = 'cp';
    if (isWindows) {
      cmd = 'copy';
    }
    final envCopy = logger.progress(
        'Generating .env files for development, staging and production');
    await Cli.run(cmd, ['.env.example', '.env-production'],
        workingDirectory: path);
    await Cli.run(cmd, ['.env.example', '.env-development'],
        workingDirectory: path);
    await Cli.run(cmd, ['.env.example', '.env-staging'],
        workingDirectory: path);
    envCopy.complete(
        'Generated .env files for development, staging and production');
  }

  static Future<void> runProject(
      {String cwd = '.', String flavor = 'development'}) async {
    await Cli.start(
        'flutter', ['run', '-t', 'lib/main-$flavor.dart', '--flavor', flavor],
        workingDirectory: cwd);
  }

  static bool isFlutterRoot() {
    final currentDirectory = Directory.current;
    final pubspecFile =
        File(p.join(currentDirectory.absolute.path, 'pubspec.yaml'));
    return pubspecFile.existsSync();
  }
}
