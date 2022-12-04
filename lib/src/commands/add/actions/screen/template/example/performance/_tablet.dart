import 'package:change_case/change_case.dart';
import 'package:project_cli/src/commands/add/actions/screen/screen_command.dart';

extension $TabletView on ScreenParameters {
  String get tabletViewContent => """
part of 'screen.dart';

class _Tablet extends GetView<${screenName.toPascalCase()}Controller> {
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

  String get tabletViewDartPath =>
      "/lib/ui/screens/${screenName.toSnakeCase()}/performance/_tablet.dart";
}
