part of "../git.dart";

class Push extends Command<int> {
  final Logger logger;

  Push(this.logger);
  @override
  // TODO: implement description
  String get description => "Push all with you branch";

  @override
  // TODO: implement name
  String get name => "push";
}
