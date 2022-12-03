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

  static Map<String, List<String>> get allPatches {
    final routers = File("$dirPath/.cli/routers.json").readAsStringSync();
    final collection = JsonDecoder().convert(routers) as Map;
    Map<String, List<String>> allPatches = {};
    void mappedJson(Map<String, dynamic> map, String parent) {
      for (var element in map.entries) {
        var screenName = element.key;
        if (element.value is String) {
          if (allPatches[screenName] == null) {
            allPatches[screenName] = [element.value as String];
          } else {
            allPatches[screenName]?.add(element.value as String);
          }
        } else {
          mappedJson(element.value as Map<String, dynamic>,
              screenName.replaceFirst(RegExp(r"@"), ""));
        }
      }
    }

    mappedJson(collection as Map<String, dynamic>, "");

    return allPatches;
  }
}

void main() {
  Helper.allPatches;
}
