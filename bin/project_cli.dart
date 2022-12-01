import 'dart:io';

import 'package:project_cli/project_cli.dart';

Future<void> main(List<String> args) async {
  await _flushThenExit(await Cli().run([
    "html",
    "clean",
  ]));
  await _flushThenExit(await Cli().run(args));
}

Future<void> _flushThenExit(int status) {
  return Future.wait<void>([stdout.close(), stderr.close()])
      .then<void>((_) => exit(status));
}
