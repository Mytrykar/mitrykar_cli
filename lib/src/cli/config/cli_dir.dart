import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:project_cli/src/cli/config/cli_yaml.dart';
import 'package:project_cli/src/cli/config/template/config.dart';
import 'package:project_cli/src/cli/config/template/routers.dart';
import 'package:project_cli/src/utils.dart';

enum ConfigFile { config, routers, tags }

class ConfigDirectory {
  Directory _configDir = Directory("${Directory.current.path}/.cli");

  Directory get configDir => _configDir;

  ConfigDirectory({String? pathProject}) {
    if (pathProject != null) {
      _configDir = Directory("$pathProject/.cli");
    }
  }

  Map<String, String> get tree => <String, String>{
        "config": "${_configDir.path}/config.yaml",
        "routers": "${_configDir.path}/routers.json",
        "tags": "${_configDir.path}/tags.md"
      };

  Future<void> init(ProjectType projectType) async {
    try {
      switch (projectType) {
        case ProjectType.app:
          _initFlutterProjectConfig();
          break;
        case ProjectType.server:
          _initServerProjectConfig();
          break;
        case ProjectType.website:
          _initDartAppProjectConfig();
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _initFlutterProjectConfig() async {
    await _create(ConfigFile.config, templateConfig(ProjectType.app));
    final Routers routers =
        Routers.fromJsonFile(tree[ConfigFile.routers.name]!);
    routers.add("/", "Root");

    await _create(ConfigFile.routers, routers.toJsonFile());
  }

  Future<void> _initDartAppProjectConfig() async {
    //TODO налаштувати ініціалізацію DartApp
  }

  Future<void> _initServerProjectConfig() async {
    //TODO налаштувати ініціалізацію server
  }

  Future<void> _create(ConfigFile configFile, String content) async {
    assert(tree[configFile.name] != null);
    File(tree[configFile.name]!)
      ..createSync()
      ..writeAsStringSync(content);
  }

  // static Future<bool> get isFlutterApp =>
  //     _CliYaml._checkProjectType(ProjectType.app);
}
