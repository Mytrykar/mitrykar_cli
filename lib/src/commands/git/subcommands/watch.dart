part of "../git.dart";

class Watch extends Command<int> {
  Watch(this.logger) {
    argParser
      ..addOption("path",
          abbr: "p",
          help:
              "the path to the file where git is initialized, and has a remote repository")
      ..addOption("timer-diration", defaultsTo: "2", help: "def 2 min");
  }
  final Logger logger;
  @override
  String get description =>
      "cli monitors remote repositories and updates the changes if they change";

  @override
  String get name => "watch";

  @override
  Future<int> run() async {
    final repo = _repo;
    var watchList = <String>[];
    if (repo != null && _dirHaveGit(Directory(repo))) {
      watchList = [repo];
    } else {
      final repo = _moreRepo;
      watchList = repo;
    }

    return await runTimer(watchList);
  }

  Future<int> runTimer(List<String> repo) async {
    if (repo.isEmpty) return ExitCode.noInput.code;
    bool run = true;
    while (run) {
      await GitCli.watch(repo, logger);
      await Future.delayed(Duration(seconds: 20));
    }
    // return ExitCode.success.code;
  }

  String? get _repo {
    return argResults?["path"];
  }

  List<String> get _moreRepo {
    var projects = <String>[];
    final dir = Directory.current;
    for (var element in dir.listSync()) {
      if (element is Directory) {
        if (_dirHaveGit(element)) projects.add(element.path);
      }
    }
    if (projects.isEmpty) return [];
    return logger.chooseAny("Select the projects you want to watch:",
        choices: projects);
  }

  bool _dirHaveGit(Directory dir) {
    if (Directory("${dir.path}/.git").existsSync()) return true;
    return false;
  }
}
