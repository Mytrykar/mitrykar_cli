import 'dart:convert';
import 'dart:io';

class Routers {
  final Map<String, String> routers;
  factory Routers.fromJsonFile(String path) {
    final file = File(path).readAsStringSync();
    final map = JsonDecoder().convert(file) as Map<String, String>;
    return Routers(map);
  }
  String toJsonFile() => JsonEncoder().convert(routers);

  Routers(this.routers);

  void add(String route, String className) => routers[route] = className;
}
