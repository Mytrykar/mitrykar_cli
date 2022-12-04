import 'package:change_case/change_case.dart';
import 'package:project_cli/src/commands/add/actions/screen/screen_command.dart';

extension $MobileView on ScreenParameters {
  String get mobileViewContent => """
part of 'screen.dart';

class _Mobile extends GetView<${screenName.toPascalCase()}Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (p0, p1) {
          return Container();
        },
      ),
    );
  }
}
""";

  String get mobileViewDartPath =>
      "/lib/ui/screens/${screenName.toSnakeCase()}/performance/_mobile.dart";
}
