part of '../create.dart';

const List<String> allPlatfoms = [
  "android",
  "ios",
  "web",
  "linux",
  "macos",
  "windows"
];

class CreateApp extends Command<int> {
  final Logger logger;
  CreateApp(this.logger) {
    argParser
      ..addOption(
        'path',
        help: 'The directory path for the project.',
      )
      ..addMultiOption("platforms", help: "Develop on platforms");
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
    // final projectName = "projectName";
    final dir = _dir;
    // final dir = "dir";
    final platforms = _platforms;
    // final platforms = allPlatfoms;
    final path = join(Directory.current.path, dir);
    logger.progress("!T! = Підготовка проекту");
    if (!await FlutterCli.isFlutterProject(path)) {
      await FlutterCli.create(logger,
          dir: dir,
          projectType: ProjectType.app,
          projectName: projectName,
          platforms: platforms.join(","));
    }
    if (!await Cli.isProjectCreating(path)) {
      // await Future.delayed(Duration(seconds: 5));
      if (await Directory("$path/lib").list().length == 1) {
        await File("$path/lib/main.dart").delete();
      }
      final template = MasonFlutterProject.templateApp(projectName, path);
      // TODO змінити $projectName на ${projectName.toLoverCase}
      // print(template.values.first);
      await Cli.create(template);
      logger.info("""
Create basic folder structure
""");
      final locale = _l10n;
      // final locale = "en";
      logger.info(""""
Generated  intl""");
      await IntlCli(path, logger).init(locale);
      logger.info("""
add basic dependensies""");
      await pubAddDed(path, platforms);

      logger.info("""
add basic dev dependensies""");
      await pubAddDEVDed(path);

      logger.info("flutter pub get");
      await FlutterCli.pubGet(cwd: path);
      logger.success("Add done.");
    }

    return ExitCode.success.code;
  }

  List<String> get _platforms {
    return logger.chooseAny("Enter the platforms",
        choices: allPlatfoms,
        defaultValues: allPlatfoms.getRange(0, 3).toList());
  }

  String get _l10n {
    return logger.prompt("Enter basic locale:", defaultValue: "en");
  }

  String get _dir {
    return argResults?['path'] ??
        logger.prompt(
          'Folder',
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

  Future<void> pubAddDEVDed(String path) async {
    final listDep = [
      "flutter_native_splash",
      "retrofit_generator",
      "build_runner",
      "json_serializable",
      "built_value_generator",
      "bloc_test",
      "mocktail",
      "mock_web_server",
      "flutter_launcher_icons",
      "injectable_generator",
      "build_verify",
      "go_router_builder"
    ];
    for (var package in listDep) {
      await FlutterCli.pubAddDEVDed(package, path);
    }
  }

  Future<void> pubAddDed(String path, List<String> platforms) async {
    await FlutterCli.pubAdd("flutter_bloc", path);
    await FlutterCli.pubAdd("equatable", path);
    await FlutterCli.pubAdd("shared_preferences", path);
    await FlutterCli.pubAdd("retrofit", path);
    // await FlutterCli.pubAdd("cached_network_image", path);
    await FlutterCli.pubAdd("dio", path);
    await FlutterCli.pubAdd("built_value", path);
    await FlutterCli.pubAdd("json_annotation", path);
    await FlutterCli.pubAdd("bloc", path);
    await FlutterCli.pubAdd("get", path);
    await FlutterCli.pubAdd("go_router", path);
    await FlutterCli.pubAdd("path_provider", path);
    // await FlutterCli.pubAdd("responsive_builder", path);
    await FlutterCli.pubAdd("logger", path);
    await FlutterCli.pubAdd("get_it", path);
    await FlutterCli.pubAdd("injectable", path);

    // await FlutterCli.pubAdd("image_picker", path);

    // if (platforms.contains("android") ||
    //     platforms.contains("ios") ||
    //     platforms.contains("linux") ||
    //     platforms.contains("macos")) {
    //   await FlutterCli.pubAdd("flutter_local_notifications", path);
    //   if (!platforms.contains("linux")) {
    //     await FlutterCli.pubAdd("cached_network_image", path);
    //   }
    // }

    // if (platforms.contains("android") || platforms.contains("ios")) {
    //   await FlutterCli.pubAdd("permission_handler", path);
    //   await FlutterCli.pubAdd("webview_flutter", path);
    // }
    // await FlutterCli.pubAdd("device_info_plus", path);
    await FlutterCli.pubAdd("rxdart", path);
    // await FlutterCli.pubAdd("flutter_secure_storage", path);
    // await FlutterCli.pubAdd("badges", path);
    // await FlutterCli.pubAdd("flutter_spinkit", path);
    // await FlutterCli.pubAdd("auto_size_text", path);
  }
}
