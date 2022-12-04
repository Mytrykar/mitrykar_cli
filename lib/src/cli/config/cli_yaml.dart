import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:yaml/yaml.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:plain_optional/src/optional.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:json2yaml/src/json2yaml.dart';

class ConfigYamlNotFound implements Exception {}

class ConfigYaml {
  final String projectType;
  final Optional<String> version;
  final Optional<String> pathRoute;

  ConfigYaml(
      {required this.projectType,
      required this.version,
      required this.pathRoute});

  /// Imports ConfigYaml from a YAML string
  factory ConfigYaml.loadFromYamlString(String content) {
    assert(content.trim().isNotEmpty, 'content must not be empty');
    return _loadFromYaml(content);
  }

  static ConfigYaml _loadFromYaml(String content) {
    final jsonMap =
        json.decode(json.encode(loadYaml(content))) as Map<String, dynamic>;
    return ConfigYaml(
        projectType: jsonMap[ConfigYamlTokens.projectType] as String,
        version: Optional(jsonMap[ConfigYamlTokens.version] as String?),
        pathRoute: Optional(jsonMap[ConfigYamlTokens.pathRoute] as String?));
  }

  /// Exports PubspecYaml instance as a YAML string
  String toYamlString() => _formatToYaml(this);
}

class ConfigYamlTokens {
  static const projectType = 'project-type';
  static const version = 'version';
  static const pathRoute = 'routes-path';
}

/// Extension class on String to import ConfigYaml from a YAML string
extension ConfigYamlFromYamlString on String {
  /// Creates ConfigYaml from a YAML string
  ConfigYaml toPubspecYaml() => ConfigYaml.loadFromYamlString(this);
}

// =============================================================================
// Implementation details
// =============================================================================

String _formatToYaml(ConfigYaml configYaml) => json2yaml(
      _pubspecYamlToJson(configYaml),
      yamlStyle: YamlStyle.pubspecYaml,
    );

Map<String, dynamic> _pubspecYamlToJson(ConfigYaml configYaml) =>
    <String, dynamic>{
      ..._packageMetadataToJson(configYaml),
    };
Map<String, dynamic> _packageMetadataToJson(ConfigYaml configYaml) =>
    <String, dynamic>{
      ConfigYamlTokens.projectType: configYaml.projectType,
      if (configYaml.version.hasValue)
        ConfigYamlTokens.version: configYaml.version.valueOr(() => ''),
      if (configYaml.pathRoute.hasValue)
        ConfigYamlTokens.pathRoute: configYaml.pathRoute.valueOr(() => ''),
    };
