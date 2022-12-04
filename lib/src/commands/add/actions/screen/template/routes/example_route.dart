import 'package:change_case/change_case.dart';
import 'package:date_format/date_format.dart';
import 'package:project_cli/src/commands/add/actions/screen/screen_command.dart';

extension $ExampleRoute on ScreenParameters {
  String exampleRouteContent(String? paramName, paramType) {
    final n = DateTime.now();
    String date =
        formatDate(DateTime(n.year, n.month, n.day), [yyyy, '-', mm, '-', dd]);
    String time = formatDate(
        DateTime(n.year, n.month, n.day, n.hour, n.minute, n.second),
        [HH, ':', nn, ':', ss]);
    return """
// This file is created using project_cli. Cli only creates this file.
// You can edit this file without restrictions.
// Then execute
// --
// dart pub global run build_runner build -d
// --
// to generate the Go_router file.
// Gen $date $time

part of '../router.dart';

class ${screenName.toPascalCase()}Route extends GoRouteData {
  const ${screenName.toPascalCase()}Route(${paramName != null ? 'this.$paramName' : ''});
  ${paramType != null ? 'final $paramType $paramName;' : ''}

  @override
  Widget build(BuildContext context) => HomeScreen(tag: tag);
}
""";
  }

  String get exampleRouteDartPath =>
      "/lib/app/router/routes/${screenName.toSnakeCase()}_route.dart";
}
