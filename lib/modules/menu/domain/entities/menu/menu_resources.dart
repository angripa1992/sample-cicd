class MenuResource {
  final int providerID;
  final String type;
  final List<MenuResourcePaths> paths;

  MenuResource({
    required this.providerID,
    required this.type,
    required this.paths,
  });
}

class MenuResourcePaths {
  final String path;
  final int sequence;
  final bool byDefault;

  MenuResourcePaths({
    required this.path,
    required this.sequence,
    required this.byDefault,
  });
}
