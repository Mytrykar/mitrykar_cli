import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
part 'actions.dart';

class AddCommand extends Command<int> {
  final Logger logger;

  AddCommand({required this.logger});
  @override
  String get description => "Додайте до свого проекту шаблони розробника";

  @override
  String get name => "add";
}
