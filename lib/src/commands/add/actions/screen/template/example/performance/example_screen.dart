import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_app/app/core/base/base_screen.dart';
import 'package:project_app/ui/screens/example/performance/screen_controller.dart';

part '_desktop.dart';
part '_mobile.dart';
part '_tablet.dart';
part '_watch.dart';

class ExampleScreen extends BaseScreen<ExampleScreenController> {
  ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: ExampleScreenController(),
        autoRemove: true,
        builder: (i) => screen.responsiveValue(
              desktop: _Desktop(),
              mobile: _Mobile(),
              tablet: _Tablet(),
              watch: _Watch(),
            )!);
  }
}
