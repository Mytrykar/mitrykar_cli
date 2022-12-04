import 'package:change_case/change_case.dart';
import 'package:project_cli/src/commands/add/actions/screen/screen_command.dart';

extension $ExampleScreen on ScreenParameters {
  String get examplescreenContent => """
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:$projectName/app/core/base/base_screen.dart';
import 'package:$projectName/ui/screens/example/performance/screen_controller.dart';

part '_desktop.dart';
part '_mobile.dart';
part '_tablet.dart';
part '_watch.dart';

class ${screenName.toPascalCase()}Screen extends BaseScreen<${screenName.toPascalCase()}Controller> {
  ${screenName.toPascalCase()}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: ${screenName.toPascalCase()}Controller(),
        autoRemove: true,
        builder: (i) => screen.responsiveValue(
              desktop: _Desktop(),
              mobile: _Mobile(),
              tablet: _Tablet(),
              watch: _Watch(),
            )!);
  }
}
""";

  String get examplescreenDartPath =>
      "/lib/ui/screens/${screenName.toSnakeCase()}/performance/screen.dart";
}
