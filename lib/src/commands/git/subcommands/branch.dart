part of "../git.dart";

class Branch extends Command<int> {
  final Logger logger;

  Branch(this.logger) {
    argParser.addFlag("delete",
        abbr: "d", help: """Delete one branch.-> mitrykar_cli git branch -d foo
            Delete any branch in list.-> mitrykar_cli git branch -d""");
  }
  @override
  String get description =>
      "Alter branch, development with you Git repository. If not, it creates a new one.";

  @override
  String get name => "branch";

  @override
  Future<int> run() async {
    if (await _checkInputConsole()) return ExitCode.success.code;
    final branches = await GitCli.branches;
    if (argResults!["delete"]) {
      var list = _delete(branches);
      await GitCli.delete(list);
    } else {
      var value = _checkout(branches);
      if (value == "create new") {
        value = logger.prompt("Enter branch:");
        await GitCli.checkout(value, true);
      } else {
        await GitCli.checkout(value, false);
      }
    }

    return ExitCode.success.code;
  }

  Future<bool> _checkInputConsole() async {
    if (argResults!.rest.isEmpty) return false;
    if (argResults!["delete"]) {
      await Cli.run("git",
          ["branch", argResults!.rest.first, argResults!.arguments.last]);
    } else {
      final list = await GitCli.branches;
      await GitCli.checkout(
          argResults!.rest.first, list.contains(argResults!.rest.first));
    }
    return true;
  }

  List<String> _delete(List<String> branches) {
    return logger.chooseAny<String>(
      "Select the branches you want to delete:",
      choices: branches,
    );
  }

  String _checkout(List<String> branches) {
    branches.add("create new");
    return logger.chooseOne<String>(
      "Choose branch:",
      choices: branches,
      defaultValue: GitCli.currentBranch(branches),
    );
  }
}
