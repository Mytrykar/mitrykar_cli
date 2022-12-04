import 'package:change_case/change_case.dart';
import 'package:project_cli/src/commands/add/actions/screen/screen_command.dart';

extension $Index on ScreenParameters {
  String get indexDartContent => """
library ${screenName..toSnakeCase()};

export 'performance/${screenName.toSnakeCase()}.dart';
""";

  String get indexDartPath =>
      "/lib/ui/screens/${screenName.toSnakeCase()}/index.dart";
}
