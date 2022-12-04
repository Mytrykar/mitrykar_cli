// This file is created using project_cli. Cli only creates this file.
// You can edit this file without restrictions.
// Then execute
// --
// dart pub global run build_runner build -d
// --
// to generate the Go_router file.
// Gen Date 3.12.2022 Time 07.24

part of '../router.dart';

class ExampleRoute2 extends GoRouteData {
  const ExampleRoute2(this.tag);
  final String tag;

  @override
  Widget build(BuildContext context) => HomeScreen(tag: tag);
}
