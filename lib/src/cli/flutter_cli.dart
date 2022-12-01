part of 'cli.dart';

/// Thrown when `flutter packages get` or `flutter pub get`
/// is executed without a `pubspec.yaml`.
class PubspecNotFound implements Exception {}

class FlutterCli {
  static Future<void> pubAdd(String package, path) async {
    await Cli.run("flutter", ["pub", "add", package], workingDirectory: path);
    await Future.delayed(Duration(seconds: 1));
    Logger().progress("Add $package");
  }

  static Future<void> pubAddDEVDed(String package, path) async {
    await Cli.run("flutter", ["pub", "add", package, "--dev"],
        workingDirectory: path);
    Logger().progress("Add dev $package");
  }

  static Future<void> create(Logger logger,
      {required ProjectType projectType,
      required String projectName,
      path,
      platforms}) async {
    assert(projectType == ProjectType.app);
    logger.progress("Create Flutter App");
    try {
      await Cli.run(
          'flutter',
          [
            'create',
            path,
            "--project-name",
            projectName,
            "--platforms=$platforms"
          ],
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
    await Cli.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: cwd,
    );
  }

  /// run generators (`flutter pub run build_runner build --delete-conflicting-outputs`).
  static Future<void> runBuildRunner({
    String cwd = '.',
    bool recursive = false,
  }) async {
    await Cli.start(
      'flutter',
      ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: cwd,
    );
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
}
