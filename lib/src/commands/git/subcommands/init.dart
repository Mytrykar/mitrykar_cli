part of "../git.dart";

class Init extends Command<int> {
  final Logger logger;

  Init(this.logger) {
    argParser.addFlag(
      'remote',
      abbr: 'r',
      help:
          'A link to your git repository. example :https://github.com/you_profile/you_repository.git',
      defaultsTo: null,
    );
  }
  @override
  String get description => "Initialization GIT with you project.";

  @override
  String get name => "init";

  @override
  String get invocation =>
      "${c.description} git $name or ${c.description} git $name https://github.com/you_profile/you_repository.git -r";

  @override
  Future<int> run() async {
    if (argResults!.arguments.isNotEmpty && !argResults!["remote"]) {
      logger.warn("You are using it incorrectly initialize git");
      return ExitCode.cantCreate.code;
    }
    var remote = _remote;
    while (remote == "err") {
      logger.warn("You must specify a repository");
      remote = _remote;
    }

    await GitCli.runBasicGitInit(logger,
        path: Directory.current.path, remoteRepo: remote);

    return ExitCode.success.code;
  }

  String get _remote {
    return argResults?.rest.first ??
        logger.prompt(
          'You git remote repo',
          defaultValue: "err",
        );
  }
}
