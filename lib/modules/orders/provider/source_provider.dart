import '../domain/entities/source.dart';
import '../domain/repository/orders_repository.dart';

class SourceProvider {
  final OrderRepository _orderRepository;
  List<Source> _sources = [];

  SourceProvider(this._orderRepository);

  Future<List<Source>> fetchSources() async {
    if (_sources.isEmpty) {
      final response = await _orderRepository.fetchSources();
      if (response.isRight()) {
        final sources = response.getOrElse(() => []);
        final data = <Source>[];
        for (var source in sources) {
          data.addAll(source.sources);
        }
        _sources = data;
        return _sources;
      } else {
        return [];
      }
    } else {
      return _sources;
    }
  }

  Future<Source> findSourceById(int sourceId) async {
    if (_sources.isEmpty) {
      final sources = await fetchSources();
      _sources = sources;
    }
    return _sources.firstWhere((element) => element.id == sourceId);
  }

  void clear() {
    _sources.clear();
  }
}
