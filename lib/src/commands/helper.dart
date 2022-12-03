import 'dart:convert';
import 'dart:io';

import 'package:project_cli/src/utils.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';

class Helper with _CliDirectory,_Routers{
  
  static Future<bool> checkProjectType(ProjectType projectType) async {
    if (!checkCreateInCli()) return false;
    final yaml = await File("$dirPath/.cli/cli.yaml").readAsLines();
    return yaml.first.startsWith("project-type: $projectType");
  }

  

  static String get projectName {
    PubspecYaml yaml =
        File("/$dirPath/pubspec.yaml").readAsStringSync().toPubspecYaml();
    return yaml.name;
  }

}

mixin _CliYaml{}

mixin _CliDirectory{
  static String get dirPath => Directory.current.path;
  static checkCreateInCli() => Directory("$dirPath/.cli").existsSync();

  static void createCliDir() => Directory("$dirPath/.cli").createSync();
}

mixin _Routers{
   static List<String> get allPatches {
    final routers = File("$dirPath/.cli/routers.json").readAsStringSync();
    final collection = JsonDecoder().convert(routers) as Map;
    List<String> allPatches = [];
    void mappedJson(Map<String, dynamic> map, String parent) {
      for (var element in map.entries) {
        if (element.value is String) {
          allPatches.add(parent + element.value);
        } else {
          mappedJson(element.value as Map<String, dynamic>, parent + );
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
