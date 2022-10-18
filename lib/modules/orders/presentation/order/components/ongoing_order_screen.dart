import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/core/provider/order_parameter_provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_item/ongoing_order_item.dart';
import 'package:klikit/modules/orders/presentation/order/components/progress_indicator.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../bloc/orders/ongoing_order_cubit.dart';
import '../../bloc/orders/order_action_cubit.dart';
import '../observer/filter_observer.dart';
import '../observer/filter_subject.dart';
import 'action_dialogs.dart';
import 'details/order_details_bottom_sheet.dart';

class OngoingOrderScreen extends StatefulWidget {
  final FilterSubject subject;

  const OngoingOrderScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<OngoingOrderScreen> createState() => _OngoingOrderScreenState();
}

class _OngoingOrderScreenState extends State<OngoingOrderScreen>
    with FilterObserver {
  final _orderRepository = getIt.get<OrderRepository>();
  final _orderParamProvider = getIt.get<OrderParameterProvider>();
  static const _pageSize = 10;
  static const _firstPageKey = 1;
  Timer? _timer;
  List<int>? _providers;
  List<int>? _brands;

  PagingController<int, Order>? _pagingController;

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: _firstPageKey);
    filterSubject = widget.subject;
    filterSubject?.addObserver(this, ObserverTag.ONGOING_ORDER);
    _providers = filterSubject?.getProviders();
    _brands = filterSubject?.getBrands();
    _startTimer();
    _pagingController?.addPageRequestListener((pageKey) {
      _fetchOngoingOrder(pageKey);
    });
    super.initState();
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

  void _refreshOrderCount() {
    context.read<OngoingOrderCubit>().fetchOngoingOrder(
          willShowLoading: false,
          providersID: _providers,
          brandsID: _brands,
        );
  }

  void _fetchOngoingOrder(int pageKey) async {
    final params = await _orderParamProvider.getOngoingOrderParams(
      _brands,
      _providers,
      pageSize: _pageSize,
    );
    params['page'] = pageKey;
    final response = await _orderRepository.fetchOrder(params);
    response.fold(
      (failure) {
        _pagingController?.error = failure;
      },
      (orders) {
        final isLastPage = orders.total < (pageKey * _pageSize);
        if (isLastPage) {
          _pagingController?.appendLastPage(orders.data);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController?.appendPage(orders.data, nextPageKey);
        }
      },
    );
  }

  void _refresh({bool willBackground = false}) {
    _refreshOrderCount();
    if (willBackground) {
      _pagingController?.itemList?.clear();
      _pagingController?.notifyPageRequestListeners(_firstPageKey);
    } else {
      _pagingController?.refresh();
    }
  }

  void _onAction({
    required String title,
    required Order order,
    bool willCancel = false,
    bool isFromDetails = false,
  }) {
    showOrderActionDialog(
      params: _orderParamProvider.getOrderActionParams(order, willCancel),
      context: context,
      onSuccess: () {
        _refresh(willBackground: true);
        if (isFromDetails) {
          Navigator.of(context).pop();
        }
      },
      title: title,
      cubit: context.read<OrderActionCubit>(),
    );
  }

  void _onPrint() {}

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Order>(
      pagingController: _pagingController!,
      builderDelegate: PagedChildBuilderDelegate<Order>(
        itemBuilder: (context, item, index) {
          return OngoingOrderItemView(
            order: item,
            seeDetails: () {
              showOrderDetails(
                context: context,
                order: item,
                onAction: (title) {
                  _onAction(
                    title: title,
                    order: item,
                    isFromDetails: true,
                  );
                },
                onPrint: _onPrint,
                onCancel: (title) {
                  _onAction(
                    title: title,
                    order: item,
                    isFromDetails: true,
                    willCancel: true,
                  );
                },
              );
            },
            onAction: (title) {
              _onAction(
                title: title,
                order: item,
              );
            },
            onPrint: _onPrint,
            onCancel: (title) {
              _onAction(
                title: title,
                order: item,
                willCancel: true,
              );
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
    _pagingController?.dispose();
    filterSubject?.removeObserver(ObserverTag.ONGOING_ORDER);
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
