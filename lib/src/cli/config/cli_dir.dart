import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:project_cli/src/cli/config/cli_yaml.dart';
import 'package:project_cli/src/cli/config/template/config.dart';
import 'package:project_cli/src/utils.dart';

enum ConfigFile { config, routers, tags }

class ConfigDirectory {
  Directory _configDir = Directory("${Directory.current.path}/.cli");

  Directory get configDir => _configDir;

  ConfigDirectory(String? pathProject) {
    _configDir = Directory("$pathProject/.cli");
  }

  Map<String, String?> get tree => <String, String?>{
        "config": "$_configDir/config.yaml",
        "routers": "$_configDir/routers.json",
        "tags": "$_configDir/tags.md"
      };

  Future<void> init(ProjectType projectType) async {
    try {} catch (e) {
      rethrow;
    }
  }

  Future<void> _initFlutterProjectConfig() async {
    await _create(ConfigFile.config, templateConfig(ProjectType.app));
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
