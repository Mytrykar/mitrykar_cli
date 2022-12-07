// ignore_for_file: depend_on_referenced_packages

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:project_cli/src/commands/add/actions/bloc_widget_command.dart';
import 'package:project_cli/src/commands/add/actions/screen_command.dart';
import 'package:project_cli/src/commands/add/actions/widget_command.dart';

class AddCommand extends Command<int> {
  final Logger logger;

  AddCommand({required this.logger}) {
    addSubcommand(Screen(logger));
    addSubcommand(Widget(logger));
    addSubcommand(BlocWidget(logger));
  }
  @override
  String get description => "Додайте до свого проекту шаблони розробника";

  @override
  String get name => "add";
}
