part of '../create.dart';

class CreateStaticWebSite extends Command<int> {
  final Logger logger;

  CreateStaticWebSite(this.logger);
  @override
  String get description => "Створіть статичний Web сайт мовою dart";

  @override
  String get name => "website";
  @override
  String get invocation => '$executableName $create $name <project_name>';
}
