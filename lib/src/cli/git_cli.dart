part of 'cli.dart';

class GitCli {
  static Future<void> watch(List<String> repo, Logger logger) async {
    for (var element in repo) {
      final response =
          await Cli.run("git", ["pull"], workingDirectory: element);
      if (response.stdout != null) {
        logger.info(response.stdout as String);
      }
    }
  }

  static Future<void> push(Logger logger, String commit) async {
    await Cli.run("git", ["add", "."]);
    await Cli.run('git', ['commit', "-m", commit]);
    await Cli.run("git", ["push"]);
    logger.success("All done");
  }

  static String currentBranch(List<String> branches) {
    return branches.firstWhere((element) => element.contains("->"));
  }

  static Future<void> pull(Logger logger) async {
    final result = await Cli.run("git", ["fetch"]);
    if (result.stdout == "") {
      logger.write("There is nothing to download!!!");
    } else {
      await Cli.run("git", ["pull"]);
    }
  }

  static Future<void> delete(List<String> branches) async {
    for (var element in branches) {
      await Cli.run("git", ["branch", element, "-d"]);
    }
  }

  static Future<void> checkout(String branch, bool isnew) async {
    try {
      if (isnew) {
        await Cli.run('git', ['checkout', "-b", branch]);
      } else {
        await Cli.run('git', ['checkout', branch]);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<String>> get branches async {
    try {
      final result = await Cli.run("git", ["branch"]);
      return _GitHelper._branches(result.stdout as String);
    } catch (e) {
      rethrow;
    }
  }

  /// Determines whether git is installed.
  static Future<bool> checkGitInstalled() async {
    try {
      await Cli.run('git', ['--version']);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Initialize the git in current directory.
  static Future<void> runBasicGitInit(Logger logger,
      {required String path, required String remoteRepo}) async {
    if (await checkGitInstalled()) {
      final gitProgress = logger.progress('Initializing git repository...');
      if (!Directory("$path/.git").existsSync()) {
        await Cli.run(
          'git',
          ['init', '--initial-branch', 'main'],
        );
      }
      await Cli.run("git", ["remote", "add", "origin", remoteRepo],
          workingDirectory: path);
      await Cli.run('git', ['add', '.'], workingDirectory: path);
      await Cli.run('git', ['commit', '-m "Setup: initial project setup"'],
          workingDirectory: path);
      gitProgress.complete('Initialized git repository....');
    } else {
      logger.confirm("Git nol installed! Install?");
      return;
    }
  }
}

mixin _GitHelper {
  static List<String> _branches(String inputValue) {
    final list = inputValue.split(" ")
      ..join(" ")
      ..removeWhere((element) => element.isEmpty);
    var newList = <String>[];
    bool moveNext = false;
    for (var element in list) {
      if (moveNext) {
        element = "->$element";
        moveNext = false;
      }
      if (element.endsWith("""
*""")) {
        moveNext = true;
      }
      var newe = "";
      for (int value in element.codeUnits) {
        if (value != 10 && value != 42) {
          newe = newe + String.fromCharCode(value);
        }
      }
      element = newe;

      newList.add(element);
    }

    return newList;
  }
}
