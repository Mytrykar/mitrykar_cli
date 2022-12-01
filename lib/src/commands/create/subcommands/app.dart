part of '../create.dart';

const List<String> allPlatfoms = [
  "android",
  "ios",
  "web",
  "fuchsia",
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
      ..addOption("l10n", help: "Create locallization in you project")
      ..addMultiOption("platforms",
          help: "Develop on platforms", defaultsTo: allPlatfoms.getRange(0, 3));
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
    final platforms = _platforms;
    final path = join(Directory.current.path, dir);

    await FlutterCli.create(logger,
        projectType: ProjectType.app,
        projectName: projectName,
        path: path,
        platforms: platforms.fold(
            "", (previousValue, element) => "$previousValue,$element"));

    final locale = _l10n;
    await IntlCli(path, logger).init(locale);
    await pubAddDed(path, platforms);
    await pubAddDEVDed(path);

    return ExitCode.success.code;
  }

  List<String> get _platforms {
    return argResults?["platforms"] ??
        logger.chooseAny("""Enter the platforms you want to support. 
            Think carefully, because specific platform settings will be added to the project.""",
            choices: allPlatfoms,
            defaultValues: allPlatfoms.getRange(0, 3).toList());
  }

  String get _l10n {
    return argResults?['l10n'] ??
        logger.prompt("Enter basic locale:", defaultValue: "en");
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

  Future<void> pubAddDEVDed(String path) async {
    final listDep = [
      "flutter_native_splash",
      "retrofit_generator",
      "build_runner",
      "json_serializable",
      "built_value_generator",
      "bloc_test",
      "mocktail",
      "flutter_launcher_icons",
      "injectable_generator"
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
    await FlutterCli.pubAdd("cached_network_image", path);
    await FlutterCli.pubAdd("dio", path);
    await FlutterCli.pubAdd("built_value", path);
    await FlutterCli.pubAdd("json_annotation", path);
    await FlutterCli.pubAdd("bloc", path);
    await FlutterCli.pubAdd("go_router", path);
    await FlutterCli.pubAdd("path_provider", path);
    await FlutterCli.pubAdd("stacked", path);
    await FlutterCli.pubAdd("responsive_builder", path);
    await FlutterCli.pubAdd("logger", path);
    await FlutterCli.pubAdd("get_it", path);
    await FlutterCli.pubAdd("injectable", path);
    await FlutterCli.pubAdd("image_picker", path);

    if (platforms.contains("web") ||
        platforms.contains("android") ||
        platforms.contains("ios")) {
      await FlutterCli.pubAdd("image_picker", path);
      await FlutterCli.pubAdd("image_picker", path);
    }

    if (platforms.contains("android") ||
        platforms.contains("ios") ||
        platforms.contains("linux") ||
        platforms.contains("macos")) {
      await FlutterCli.pubAdd("flutter_local_notifications", path);
      if (!platforms.contains("linux")) {
        await FlutterCli.pubAdd("cached_network_image", path);
      }
    }

    if (platforms.contains("android") || platforms.contains("ios")) {
      await FlutterCli.pubAdd("permission_handler", path);
      await FlutterCli.pubAdd("webview_flutter", path);
    }
    await FlutterCli.pubAdd("device_info_plus", path);
    await FlutterCli.pubAdd("rxdart", path);
    await FlutterCli.pubAdd("flutter_secure_storage", path);
    await FlutterCli.pubAdd("badges", path);
    await FlutterCli.pubAdd("flutter_spinkit", path);
    await FlutterCli.pubAdd("auto_size_text", path);
  }
}
