import 'package:change_case/change_case.dart';
import 'package:project_cli/src/commands/add/actions/screen/screen_command.dart';

extension $DesktopView on ScreenParameters {
  String get desktopViewContent => """
part of 'screen.dart';

class _Desktop extends GetView<${screenName.toPascalCase()}Controller> {
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

  String get desktopViewDartPath =>
      "/lib/ui/screens/${screenName.toSnakeCase()}/performance/_desktop.dart";
}
