part of "../git.dart";

class Pull extends Command<int> {
  final Logger logger;

  Pull(this.logger);
  @override
  // TODO: implement description
  String get description => "Check repository, if there are changes git pull";

  @override
  // TODO: implement name
  String get name => "pull";
}
