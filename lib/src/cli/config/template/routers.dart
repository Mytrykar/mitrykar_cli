import 'dart:convert';
import 'dart:io';

import 'package:project_cli/src/cli/config/router.dart';

class Routers {
  final List<Router> routers;
  static late Map<String, dynamic> _routersMap;
  factory Routers.fromJsonFile(String path) {
    final file = File(path).readAsStringSync();
    _routersMap = JsonDecoder().convert(file) as Map<String, dynamic>;
    final allRouters = _allRouter;
    final routers = [Router("Home", "/")];
    if (allRouters.isNotEmpty) {
      for (var router in allRouters) {
        routers.add(_convert(router, _searchParents(router), allRouters));
      }
    }
    return Routers(routers);
  }

  Routers(this.routers);
  String toJsonFile(Routers routers) {}

  static Router _convert(
      Router router, List<String>? parents, List<Router> routers) {
    if (parents == null) {
      return Router(router.className, router.routeName,
          routers: [router.routeName]);
    }
    // ignore: no_leading_underscores_for_local_identifiers
    List<String> _routers = [];
    for (var element in parents) {
      final tree = element.split("|");
      String router = "";
      for (var element in tree) {
        router = router +
            routers.firstWhere((e) => e.className == element).routeName;
      }
      _routers.add(router);
    }
    return Router(router.className, router.routeName,
        parents: parents, routers: _routers);
  }

  static List<String>? _searchParents(Router router) {
    List<String> parents = [];
    _forEachMapParents(_routersMap, (p0) {
      parents.add(p0);
    }, "", router);
    if (parents.isEmpty) return null;
    return parents;
  }

  static void _forEachMapParents(Map<String, dynamic> routersMap,
      void Function(String) callback, String parent, Router child) {
    for (var element in routersMap.entries) {
      if (element.key == "Home") continue;
      if (element.key == child.className) {
        callback.call("$parent${child.routeName}");
      }
      if (element.value is Map) {
        _forEachMapParents(element.value, callback,
            "$parent|${element.key.replaceAll(RegExp(r"@"), "")}", child);
      }
    }
  }

  static List<Router> get _allRouter {
    Set<Router> result = {};
    _forEachMapChildhen(
      _routersMap,
      (router) => result.add(router),
    );
    return result.toList();
  }

  static _forEachMapChildhen(
      Map<String, dynamic> routersMap, void Function(Router) callback) {
    for (var element in routersMap.entries) {
      if (element.key == "Home") continue;
      if (element.value is String) {
        callback.call(Router(element.key, element.value));
      }
      if (element.value is Map) {
        _forEachMapChildhen(element.value as Map<String, dynamic>, callback);
      }
    }
  }
}
