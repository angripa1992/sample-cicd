import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/core/provider/order_information_provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/presentation/order/components/progress_indicator.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../domain/entities/order_status.dart';
import '../../bloc/orders/new_order_cubit.dart';
import '../observer/filter_observer.dart';
import '../observer/filter_subject.dart';
import 'order_item_view.dart';

class NewOrderScreen extends StatefulWidget {
  final FilterSubject subject;

  const NewOrderScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> with FilterObserver {
  final _orderRepository = getIt.get<OrderRepository>();
  final _informationProvider = getIt.get<OrderInformationProvider>();
  static const _pageSize = 10;
  Timer? _timer;
  List<int>? _providers;
  List<int>? _brands;

  final PagingController<int, Order> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    filterSubject = widget.subject;
    filterSubject?.addObserver(this, ObserverTag.NEW_ORDER);
    _startTimer();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchNewOrder(pageKey);
    });
    super.initState();
  }

  void _refreshOrderCount() {
    context.read<NewOrderCubit>().fetchNewOrder(
          willShowLoading: false,
          providersID: _providers,
          brandsID: _brands,
        );
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: AppConstant.refreshTime),
      (timer) {
        _refreshOrderCount();
        _pagingController.refresh();
      },
    );
  }

  void _fetchNewOrder(int pageKey) async {
    final params = await _getParams();
    params['page'] = pageKey;
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

  Future<Map<String, dynamic>> _getParams() async {
    final status = await _informationProvider.getStatusByNames(
      [OrderStatusName.PLACED, OrderStatusName.ACCEPTED],
    );
    final brands = _brands ?? await _informationProvider.getBrandsIds();
    final providers =
        _providers ?? await _informationProvider.getProvidersIds();
    final branch = await _informationProvider.getBranchId();
    return {
      "size": _pageSize,
      "filterByBranch": branch,
      "filterByBrand": ListParam<int>(brands, ListFormat.csv),
      "filterByProvider": ListParam<int>(providers, ListFormat.csv),
      "filterByStatus": ListParam<int>(status, ListFormat.csv),
    };
  }

  void _applyFilter(){
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: PagedListView<int, Order>(
        pagingController: _pagingController,
        padding: EdgeInsets.zero,
        builderDelegate: PagedChildBuilderDelegate<Order>(
          itemBuilder: (context, item, index) {
            return OrderItemView(order: item);
          },
          firstPageProgressIndicatorBuilder: (_) =>
              getFirstPageProgressIndicator(),
          newPageProgressIndicatorBuilder: (_) => getNewPageProgressIndicator(),
          newPageErrorIndicatorBuilder: (_) => getPageErrorIndicator(
            () {
              _pagingController.refresh();
            },
          ),
          firstPageErrorIndicatorBuilder: (_) => getPageErrorIndicator(
            () {
              _pagingController.refresh();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void applyBrandsFilter(List<int> brandsID) {
    _brands = brandsID;
    _applyFilter();
  }

  @override
  void applyProviderFilter(List<int> providersID) {
    _providers = providersID;
    _applyFilter();
  }
}
