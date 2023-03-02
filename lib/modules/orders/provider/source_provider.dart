import 'package:klikit/app/extensions.dart';

import '../domain/entities/source.dart';
import '../domain/repository/order_info_provider_repo.dart';

class SourceProvider {
  final OrderInfoProviderRepo _orderRepository;
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
    try {
      if (_sources.isEmpty) {
        final sources = await fetchSources();
        _sources = sources;
      }
      return _sources.firstWhere((element) => element.id == sourceId);
    } catch (e) {
      return Source(id: ZERO, name: EMPTY, image: EMPTY);
    }
  }

  void clear() {
    _sources.clear();
  }
}
