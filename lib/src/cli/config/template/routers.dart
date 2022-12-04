import 'dart:convert';
import 'dart:io';

import 'package:project_cli/src/cli/config/router.dart';

class Routers {
  List<Router> routers = [Router("Home", "/")];
  static Map<String, dynamic> _routersMap;
  factory Routers.fromJsonFile(String path) {
    final routers = File(path).readAsStringSync();
    _routersMap = JsonDecoder().convert(routers) as Map<String, dynamic>;
  }
  String toJsonFile(Routers routers) {}

  static List<Router> get _allRouter {
    Set<Router> result = {};
    for (var element in _routersMap.entries) {
      if (element.key == "Home") continue;
    }
    return result.toList();
  }

  static _forMap(
      Map<String, dynamic> routersMap, void Function(Router) callback) {
    for (var element in routersMap.entries) {
      if (element.value is String) callback.call();
    }
  }
}
