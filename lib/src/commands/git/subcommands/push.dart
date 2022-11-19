part of "../git.dart";

class Push extends Command<int> {
  final Logger logger;

  Push(this.logger);
  @override
  String get description => "Push all with you branch";

  @override
  String get name => "push";

  @override
  Future<int> run() async {
    final commit = _commit ?? Random().nextInt(100000).toString();
    final current = GitCli.currentBranch(await GitCli.branches);
    logger.info("Current branch: $current");
    logger.info("Commit: $commit");
    final remote =
        await Cli.run("git", ["config", "--get", "remote.origin.url"]);
    logger.info("Remote: ${remote.stdout}");

    if (moveNext) {
      await GitCli.push(logger, commit);
    }

    return ExitCode.success.code;
  }

  bool get moveNext =>
      logger.confirm("Push all to remote Repo", defaultValue: false);

  String? get _commit => logger.prompt("Write you commit:", defaultValue: null);
}
