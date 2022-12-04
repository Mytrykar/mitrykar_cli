import 'package:change_case/change_case.dart';
import 'package:project_cli/src/commands/add/actions/screen/screen_command.dart';

extension $ExampleController on ScreenParameters {
  String get exampleControllerContent => """
import 'package:flutter/widgets.dart';
import 'package:$projectName/app/core/base/base_view_controller.dart';

class ${screenName.toPascalCase()}Controller extends BaseController {}
""";

  String get exampleControllerDartPath =>
      "/lib/ui/screens/${screenName.toSnakeCase()}/performance/screen_controller.dart";
}
