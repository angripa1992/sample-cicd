import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/modules/common/oni_parameter_provider.dart';
import 'package:klikit/modules/orders/presentation/components/progress_indicator.dart';
import 'package:klikit/modules/orders/utils/klikit_order_resolver.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../domain/entities/order.dart';
import '../../domain/repository/orders_repository.dart';
import '../oni_filter_manager.dart';
import 'details/order_details_bottom_sheet.dart';
import 'order_item/order_item_view.dart';

class OrderHistoryScreen extends StatefulWidget {
  final OniFilterManager oniFilterManager;

  const OrderHistoryScreen({Key? key, required this.oniFilterManager}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with FilterObserver {
  final _orderRepository = getIt.get<OrderRepository>();
  final _sourceTab = 'Order History';
  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();
  static const _pageSize = 10;
  static const _firstPageKey = 1;
  Timer? _timer;
  PagingController<int, Order>? _pagingController;
  OniFilteredData? _filteredData;

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: _firstPageKey);
    widget.oniFilterManager.addObserver(this, ObserverTag.ORDER_HISTORY);
    _filteredData = widget.oniFilterManager.filteredData();
    _pagingController?.addPageRequestListener((pageKey) {
      _fetchOrderHistory(pageKey);
    });
    super.initState();
  }

  void _fetchOrderHistory(int pageKey) async {
    final params = await OniParameterProvider().historyOrder(filteredData: _filteredData, page: pageKey, pageSize: _pageSize);
    final response = await _orderRepository.fetchOrder(params);
    response.fold(
      (failure) {
        _pagingController?.error = failure;
      },
      (orders) {
        final isLastPage = orders.total <= (pageKey * _pageSize);
        if (isLastPage) {
          _pagingController?.appendLastPage(orders.data);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController?.appendPage(orders.data, nextPageKey);
        }
      },
    );
  }

  void _refresh() {
    _pagingController?.refresh();
  }

  void _showDetails(Order item) {
    showHistoryOrderDetails(
      key: _modelScaffoldKey,
      context: context,
      order: item,
      onPrint: () => KlikitOrderResolver().printDocket(
        order: item,
        isFromDetails: true,
        sourceTab: _sourceTab,
      ),
      onRefresh: () => _refresh(),
      onEditManualOrder: () {},
      onRiderFind: () {},
    );
    KlikitOrderResolver().sendOrderDetailsScreenEvent(_sourceTab);
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Order>.separated(
      pagingController: _pagingController!,
      builderDelegate: PagedChildBuilderDelegate<Order>(
        itemBuilder: (context, item, index) {
          return OrderItemView(
            order: item,
            seeDetails: () => _showDetails(item),
            onPrint: () => KlikitOrderResolver().printDocket(
              order: item,
              isFromDetails: false,
              sourceTab: _sourceTab,
            ),
            onSwitchRider: () {},
            onAction: (_, __) {},
            onCancel: (_) {},
            onEditGrabOrder: () {},
            onEditManualOrder: () {},
            onRiderFind: () {},
          );
        },
        firstPageProgressIndicatorBuilder: getFirstPageProgressIndicator,
        newPageProgressIndicatorBuilder: getNewPageProgressIndicator,
        noItemsFoundIndicatorBuilder: noItemsFoundIndicator,
        newPageErrorIndicatorBuilder: (_) => getPageErrorIndicator(() => _refresh()),
        firstPageErrorIndicatorBuilder: (_) => getPageErrorIndicator(() => _refresh()),
      ),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pagingController?.dispose();
    widget.oniFilterManager.removeObserver(ObserverTag.ORDER_HISTORY);
    super.dispose();
  }

  @override
  void applyFilter(OniFilteredData? filteredData) {
    _filteredData = filteredData;
    _refresh();
  }
}
