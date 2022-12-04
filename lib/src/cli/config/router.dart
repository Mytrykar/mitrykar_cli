class Router {
  final String className;
  final String routeName;
  final List<String>? routers;
  final List<String>? parents;
  Router(this.className, this.routeName, {this.parents, this.routers});

  @override
  bool operator ==(Object other) =>
      other is Router &&
      className == other.className &&
      routeName == other.routeName;

  @override
  int get hashCode => super.hashCode;
}
