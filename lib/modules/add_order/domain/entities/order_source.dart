class AddOrderSourceType {
  final int id;
  final String name;
  final List<AddOrderSource> sources;

  AddOrderSourceType({required this.id, required this.name, required this.sources});
}

class AddOrderSource {
  final int id;
  final String name;
  final String image;

  AddOrderSource({required this.id, required this.name, required this.image});
}
