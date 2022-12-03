import 'dart:convert';
import 'dart:io';

import 'package:project_cli/src/utils.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';

String get dirPath => Directory.current.path;

class Helper {
  static String get projectName {
    PubspecYaml yaml =
        File("/$dirPath/pubspec.yaml").readAsStringSync().toPubspecYaml();
    return yaml.name;
  }

  static List<String> get routes => _Routers._allPatches;
}

class _CliYaml {
  static Future<bool> _checkProjectType(ProjectType projectType) async {
    if (!_CliDirectory.checkCreateInCli()) return false;
    final yaml = await File("$dirPath/.cli/cli.yaml").readAsLines();
    return yaml.first.startsWith("project-type: $projectType");
  }
}

class _CliDirectory {
  static checkCreateInCli() => Directory("$dirPath/.cli").existsSync();

  static void createCliDir() => Directory("$dirPath/.cli").createSync();
}

class _Routers {
  static Map<String, dynamic>? _routersMap;

  static void readFile() {
    final routers = File("$dirPath/.cli/routers.json").readAsStringSync();
    _routersMap = JsonDecoder().convert(routers) as Map<String, dynamic>;
  }

  static List<String> get _allPatches {
    readFile();

    List<String> allPatches = [];

    _mappedJson(
      _routersMap!,
      "",
      (p0) => allPatches.add(p0),
    );
    print(allPatches);

    return allPatches;
  }

  static _mappedJson(
      Map<String, dynamic> map, String parent, void Function(String) add) {
    for (var element in map.entries) {
      if (element.value is String) {
        add.call(parent + element.value);
      } else {
        final newParant =
            parent + _searchPath(element.key.replaceFirst("@", ""), null);
        print(newParant);
        _mappedJson(element.value as Map<String, dynamic>, newParant, add);
      }
    }
  }

  static String _searchPath(String screenName, Map<String, dynamic>? map) {
    for (var element in map?.entries ?? _routersMap!.entries) {
      if (element.key == screenName) {
        return element.value;
      }
      if (element.value is Map) {
        return _searchPath(screenName, element.value);
      }
    }
    return "";
  }
}

void main() {
  Helper.routes;
}
