import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/core/provider/order_parameter_provider.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/history_order_details.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_item/history_order_item.dart';
import 'package:klikit/modules/orders/presentation/order/components/progress_indicator.dart';
import 'package:klikit/modules/orders/presentation/order/observer/filter_observer.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/repository/orders_repository.dart';
import '../observer/filter_subject.dart';
import 'date_range_picker.dart';

class OrderHistoryScreen extends StatefulWidget {
  final FilterSubject subject;

  const OrderHistoryScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with FilterObserver {
  final _orderRepository = getIt.get<OrderRepository>();
  final _orderParamProvider = getIt.get<OrderParameterProvider>();
  static const _pageSize = 10;
  static const _firstPageKey = 1;
  Timer? _timer;
  List<int>? _providers;
  List<int>? _brands;

  final PagingController<int, Order> _pagingController =
      PagingController(firstPageKey: _firstPageKey);

  DateTimeRange _dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  void initState() {
    filterSubject = widget.subject;
    filterSubject?.addObserver(this, ObserverTag.ORDER_HISTORY);
    _providers = filterSubject?.getProviders();
    _brands = filterSubject?.getBrands();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchOrderHistory(pageKey);
    });
    super.initState();
  }

  void _fetchOrderHistory(int pageKey) async {
    final params = await _orderParamProvider.getOrderHistoryParam(
      _brands,
      _providers,
      pageSize: _pageSize,
    );
    params['page'] = pageKey;
    params['start'] = DateTimeProvider.getDate(_dateRange.start);
    params['end'] = DateTimeProvider.getDate(_dateRange.end);
    final response = await _orderRepository.fetchOrder(params);
    response.fold(
      (failure) {
        _pagingController.error = failure;
      },
      (orders) {
        final isLastPage = orders.total < (pageKey * _pageSize);
        if (isLastPage) {
          _pagingController.appendLastPage(orders.data);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(orders.data, nextPageKey);
        }
      },
    );
  }

  void _refresh() {
    //_pagingController.itemList?.clear();
    //_pagingController.notifyPageRequestListeners(_firstPageKey);
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Center(
            child: DateSelector(
              dateTimeRange: _dateRange,
              onPick: (dateRange) {
                _dateRange = dateRange;
                _refresh();
              },
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: PagedListView<int, Order>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Order>(
              itemBuilder: (context, item, index) {
                return HistoryOrderItemView(
                  order: item,
                  seeDetails: (order) {
                    showHistoryOrderDetails(context,order);
                  },
                );
              },
              firstPageProgressIndicatorBuilder: (_) =>
                  getFirstPageProgressIndicator(),
              newPageProgressIndicatorBuilder: (_) =>
                  getNewPageProgressIndicator(),
              newPageErrorIndicatorBuilder: (_) =>
                  getPageErrorIndicator(() => _refresh()),
              firstPageErrorIndicatorBuilder: (_) =>
                  getPageErrorIndicator(() => _refresh()),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pagingController.dispose();
    filterSubject?.removeObserver(ObserverTag.ORDER_HISTORY);
    super.dispose();
  }

  @override
  void applyBrandsFilter(List<int> brandsID) {
    _brands = brandsID;
    _refresh();
  }

  @override
  void applyProviderFilter(List<int> providersID) {
    _providers = providersID;
    _refresh();
  }
}
