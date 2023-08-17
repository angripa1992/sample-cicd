import 'package:klikit/app/extensions.dart';

import '../domain/entities/payment_info.dart';
import '../domain/repository/order_info_provider_repo.dart';

class PaymentInfoProvider {
  final OrderInfoProviderRepo _orderRepository;
  final List<PaymentStatus> _statuses = [];
  final List<PaymentMethod> _methods = [];

  PaymentInfoProvider(this._orderRepository);

  Future<List<PaymentStatus>> fetchStatuses() async {
    if (_statuses.isEmpty) {
      final response = await _orderRepository.fetchPaymentSources();
      if (response.isRight()) {
        final statues = response.getOrElse(() => []);
        _statuses.addAll(statues);
        return _statuses;
      } else {
        return [];
      }
    } else {
      return _statuses;
    }
  }

  Future<List<PaymentMethod>> fetchMethods() async {
    if (_methods.isEmpty) {
      final response = await _orderRepository.fetchPaymentMethods();
      if (response.isRight()) {
        final methods = response.getOrElse(() => []);
        _methods.addAll(methods);
        return _methods;
      } else {
        return [];
      }
    } else {
      return _methods;
    }
  }

  Future<PaymentStatus> findStatusById(int statusId) async {
    try {
      if (_statuses.isEmpty) {
        await fetchStatuses();
      }
      return _statuses.firstWhere((element) => element.id == statusId);
    } catch (e) {
      return PaymentStatus(id: ZERO, title: EMPTY);
    }
  }

  Future<PaymentMethod> findMethodById(int methodId) async {
    try {
      if (_methods.isEmpty) {
        await fetchMethods();
      }
      return _methods.firstWhere((element) => element.id == methodId);
    } catch (e) {
      return PaymentMethod(
        id: ZERO,
        title: EMPTY,
        channels: [],
      );
    }
  }

  void clear() {
    _statuses.clear();
    _methods.clear();
  }
}
