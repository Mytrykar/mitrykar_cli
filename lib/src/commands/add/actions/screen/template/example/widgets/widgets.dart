import 'package:change_case/change_case.dart';
import 'package:project_cli/src/commands/add/actions/screen/screen_command.dart';

extension $Widgets on ScreenParameters {
  String get widgetsDartPath =>
      "/lib/ui/screens/${screenName.toSnakeCase()}/widgets";
}
