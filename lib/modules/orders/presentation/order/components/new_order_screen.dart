import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/core/provider/order_parameter_provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/presentation/order/components/progress_indicator.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../bloc/orders/new_order_cubit.dart';
import '../observer/filter_observer.dart';
import '../observer/filter_subject.dart';
import 'details/history_order_details.dart';
import 'order_item/new_order_item.dart';
import 'order_item/order_item_view.dart';

class NewOrderScreen extends StatefulWidget {
  final FilterSubject subject;

  const NewOrderScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> with FilterObserver {
  final _orderRepository = getIt.get<OrderRepository>();
  final _orderParameterProvider = getIt.get<OrderParameterProvider>();
  static const _pageSize = 10;
  static const _firstPageKey = 1;
  Timer? _timer;
  List<int>? _providers;
  List<int>? _brands;

  final PagingController<int, Order> _pagingController =
      PagingController(firstPageKey: _firstPageKey);

  @override
  void initState() {
    filterSubject = widget.subject;
    filterSubject?.addObserver(this, ObserverTag.NEW_ORDER);
    _providers = filterSubject?.getProviders();
    _brands = filterSubject?.getBrands();
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
        _refresh(willBackground: true);
      },
    );
  }

  void _fetchNewOrder(int pageKey) async {
    final params = await _orderParameterProvider.getNewOrderParams(
      _brands,
      _providers,
      pageSize: _pageSize,
    );
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

  void _refresh({bool willBackground = false}) {
    if(willBackground){
      _pagingController.itemList?.clear();
      _pagingController.notifyPageRequestListeners(_firstPageKey);
    }else{
      _pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Order>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Order>(
        itemBuilder: (context, item, index) {
          return NewOrderItemView(order: item,seeDetails: (order){
            showHistoryOrderDetails(context,order);
          },
          );
        },
        firstPageProgressIndicatorBuilder: (_) =>
            getFirstPageProgressIndicator(),
        newPageProgressIndicatorBuilder: (_) => getNewPageProgressIndicator(),
        newPageErrorIndicatorBuilder: (_) =>
            getPageErrorIndicator(() => _refresh()),
        firstPageErrorIndicatorBuilder: (_) =>
            getPageErrorIndicator(() => _refresh()),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pagingController.dispose();
    filterSubject?.removeObserver(ObserverTag.NEW_ORDER);
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
