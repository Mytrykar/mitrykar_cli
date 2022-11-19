part of "../git.dart";

class Pull extends Command<int> {
  final Logger logger;

  Pull(this.logger);

  @override
  String get description => "Check repository, if there are changes git pull";

  @override
  String get name => "pull";

  @override
  Future<int> run() async {
    await GitCli.pull(logger);
    return ExitCode.success.code;
  }
}
