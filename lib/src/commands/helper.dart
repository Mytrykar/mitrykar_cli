import 'dart:convert';
import 'dart:io';

import 'package:project_cli/src/utils.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';

String get dirPath => Directory.current.path;

class Helper with _CliDirectory, _Routers, _CliYaml {
  static String get projectName {
    PubspecYaml yaml =
        File("/$dirPath/pubspec.yaml").readAsStringSync().toPubspecYaml();
    return yaml.name;
  }
}

mixin _CliYaml {
  static Future<bool> checkProjectType(ProjectType projectType) async {
    if (!_CliDirectory.checkCreateInCli()) return false;
    final yaml = await File("$dirPath/.cli/cli.yaml").readAsLines();
    return yaml.first.startsWith("project-type: $projectType");
  }
}

mixin _CliDirectory {
  static checkCreateInCli() => Directory("$dirPath/.cli").existsSync();

  static void createCliDir() => Directory("$dirPath/.cli").createSync();
}

class _Routers {
  static Map<String, dynamic>? _routersMap;

  static void readFile() {
    final routers = File("$dirPath/.cli/routers.json").readAsStringSync();
    _routersMap = JsonDecoder().convert(routers) as Map<String, dynamic>;
  }

  static List<String> get allPatches {
    readFile();

    List<String> allPatches = [];

    _mappedJson(
      _routersMap!,
      "",
      (p0) => allPatches.add(p0),
    );

    return allPatches;
  }

  static _mappedJson(
      Map<String, dynamic> map, String parent, void Function(String) add) {
    for (var element in map.entries) {
      if (element.value is String) {
        add.call(parent + element.value);
      } else {
        _mappedJson(element.value as Map<String, dynamic>,
            parent + _searchPath(element.key), add.call);
      }
    }
  }

  static _searchPath(String screenName) {}
}

void main() {
  Helper.;
}
