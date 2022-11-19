import 'dart:io';

import 'package:mitrykar_cli/mitrykar_cli.dart';

Future<void> main(List<String> args) async {
  // await _flushThenExit(await Cli().run([
  //   "git",
  //   "branch",
  //   "dada",
  // ]));
  await _flushThenExit(await Cli().run(args));
}

Future<void> _flushThenExit(int status) {
  return Future.wait<void>([stdout.close(), stderr.close()])
      .then<void>((_) => exit(status));
}
