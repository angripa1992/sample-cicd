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

  Source({required this.id, required this.name, required this.image});
}

enum SourceTpe {
  source,
  provider,
}

class OrderSource {
  final int id;
  final String title;
  final String logo;
  final SourceTpe sourceType;

  OrderSource(this.id, this.title, this.logo, this.sourceType);

  OrderSource copy() => OrderSource(
        id,
        title,
        logo,
        sourceType,
      );
}
