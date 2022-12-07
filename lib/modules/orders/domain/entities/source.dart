class Sources {
  final int id;
  final String name;
  final List<Source> sources;

  Sources({required this.id, required this.name, required this.sources});
}

class Source {
  final int id;
  final String name;
  final String image;

  Source({required this.id,required this.name,required this.image});
}