part of '../create.dart';

class CreateApp extends Command<int> {
  final Logger logger;
  CreateApp(this.logger) {
    argParser.addOption(
      'path',
      help: 'The directory path for the project.',
    );
  }
  @override
  String get description => "Створіть Flutter app з архітектурою Stacked+Bloc";

  @override
  String get name => "app";
  @override
  String get invocation => '$executableName $create $name <project_name>';

  @override
  Future<int> run() async {
    final projectName = _projectName;
    final dir = _dir;
    final path = join(Directory.current.path, dir);

    await FlutterCli.create(logger,
        projectType: ProjectType.app, projectName: projectName, path: path);

    return ExitCode.success.code;
  }

  String get _dir {
    return argResults?['path'] ??
        logger.prompt(
          'The name of the folder where your project will be located does not affect the value in the project',
          defaultValue: 'app',
        );
  }

  String get _projectName {
    final args = argResults!.rest;
    if (args.isEmpty) {
      return logger.prompt('Project name?', defaultValue: "project");
    }
    return args.first;
  }
}
