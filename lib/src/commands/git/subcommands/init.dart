part of "../git.dart";

class Init extends Command<int> {
  final Logger logger;

  Init(this.logger);
  @override
  // TODO: implement description
  String get description => "Initialization GIT with you project.";

  @override
  // TODO: implement name
  String get name => "init";

  bool get _git {
    if (Directory(Directory.current.path).existsSync()) {
      final dir = dirname(Directory.current.path);
      final config = File("$dir/.git/config");
      final remote = config
          .readAsLinesSync()
          .firstWhere((element) => element.contains("url"));

      return argResults?['git'] ??
          logger.confirm(
            """In ${Directory.current.path} already initiated .git, 
            $remote
            are you sure you want to initiate it here?""",
            defaultValue: false,
          );
    } else {
      return argResults?['git'] ??
          logger.confirm(
            'Initialize repository Git?',
            defaultValue: false,
          );
    }
  }

  String get _remote =>
      argResults?['remote'] ??
      logger.prompt(
        """A link to your git repository. example :https://github.com/you_profile/you_repository.git""",
      );
}
