part of '../create.dart';

class CreateDartServer extends Command<int> {
  final Logger logger;

  CreateDartServer(this.logger);
  @override
  String get description => "Створіть свій Dart server";

  @override
  String get name => "server";
  @override
  String get invocation => '$executableName $create $name <project_name>';
}
