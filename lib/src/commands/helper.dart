import 'dart:convert';
import 'dart:io';

import 'package:project_cli/src/utils.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';

class Helper {
  static String get dirPath => Directory.current.path;

  static Future<bool> checkProjectType(ProjectType projectType) async {
    if (!checkCreateInCli()) return false;
    final yaml = await File("$dirPath/.cli/cli.yaml").readAsLines();
    return yaml.first.startsWith("project-type: $projectType");
  }

  static checkCreateInCli() => Directory("$dirPath/.cli").existsSync();

  static void createCliDir() => Directory("$dirPath/.cli").createSync();

  static String get projectName {
    PubspecYaml yaml =
        File("/$dirPath/pubspec.yaml").readAsStringSync().toPubspecYaml();
    return yaml.name;
  }

  static Map<String, String> get allPatches {
    final routers = File("$dirPath/.cli/router.json").readAsStringSync();
    final collection = JsonDecoder().convert(routers) as Map;
    Map<String, String> allPatches = {};

    for (var element in collection.entries) {
      var screenName = element.key as String;
      if (element.value is String) {}
    }

    return allPatches;
  }
}
