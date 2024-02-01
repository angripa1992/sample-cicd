import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/modules/common/oni_parameter_provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/presentation/components/progress_indicator.dart';
import 'package:klikit/modules/orders/utils/grab_order_resolver.dart';
import 'package:klikit/modules/orders/utils/klikit_order_resolver.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../oni_filter_manager.dart';
import 'details/order_details_bottom_sheet.dart';
import 'order_item/order_item_view.dart';

class NewOrderScreen extends StatefulWidget {
  final OniFilterManager oniFilterManager;

  const NewOrderScreen({Key? key, required this.oniFilterManager}) : super(key: key);

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> with FilterObserver {
  final _orderRepository = getIt.get<OrderRepository>();
  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();
  final _sourceTab = 'New Order';
  static const _pageSize = 10;
  static const _firstPageKey = 1;
  Timer? _timer;
  OniFilteredData? _filteredData;
  PagingController<int, Order>? _pagingController;

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: _firstPageKey);
    widget.oniFilterManager.addObserver(this, ObserverTag.NEW_ORDER);
    _filteredData = widget.oniFilterManager.filteredData();
    _startTimer();
    _pagingController?.addPageRequestListener((pageKey) {
      _fetchNewOrder(pageKey);
    });
    super.initState();
  }

  void _fetchNewOrder(int pageKey) async {
    final params = await OniParameterProvider().newOrder(filteredData: _filteredData, page: pageKey, pageSize: _pageSize);
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

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: AppConstant.refreshTime),
      (timer) {
        _refresh(willBackground: true);
      },
    );
  }

  void _refresh({bool willBackground = false, bool isFromAction = false}) {
    KlikitOrderResolver().refreshOrderCounts(context, filteredData: _filteredData);
    if (willBackground) {
      _pagingController?.itemList?.clear();
      _pagingController?.notifyPageRequestListeners(_firstPageKey);
    } else {
      _pagingController?.refresh();
    }
  }

  void _showOrderDetails(Order item) {
    showOrderDetails(
      key: _modelScaffoldKey,
      context: context,
      order: item,
      onAction: (title, status) => KlikitOrderResolver().onAction(
        context: context,
        sourceTab: 'New Order',
        title: title,
        order: item,
        isFromDetails: true,
        status: status,
        onRefresh: () => _refresh(willBackground: true, isFromAction: true),
      ),
      onPrint: () => KlikitOrderResolver().printDocket(
        order: item,
        isFromDetails: true,
        sourceTab: _sourceTab,
      ),
      onCancel: (title) => KlikitOrderResolver().cancelOrder(
        context: context,
        sourceTab: _sourceTab,
        title: title,
        order: item,
        isFromDetails: true,
        onRefresh: () => _refresh(willBackground: true, isFromAction: true),
      ),
      onRiderFind: () => KlikitOrderResolver().findRider(
        context: context,
        orderID: item.id,
        onRefresh: () => _refresh(willBackground: true),
      ),
      onEditManualOrder: () {
        Navigator.pop(context);
        KlikitOrderResolver().editManualOrder(context, item);
      },
      onRefresh: () => _refresh(willBackground: true),
    );
    KlikitOrderResolver().sendOrderDetailsScreenEvent(_sourceTab);
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Order>.separated(
      pagingController: _pagingController!,
      padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
      builderDelegate: PagedChildBuilderDelegate<Order>(
        itemBuilder: (context, item, index) {
          return OrderItemView(
            order: item,
            seeDetails: () => _showOrderDetails(item),
            onAction: (title, status) => KlikitOrderResolver().onAction(
              context: context,
              sourceTab: _sourceTab,
              title: title,
              order: item,
              isFromDetails: false,
              status: status,
              onRefresh: () => _refresh(willBackground: true, isFromAction: true),
            ),
            onPrint: () => KlikitOrderResolver().printDocket(
              order: item,
              isFromDetails: false,
              sourceTab: _sourceTab,
            ),
            onCancel: (title) => KlikitOrderResolver().cancelOrder(
              context: context,
              sourceTab: _sourceTab,
              title: title,
              order: item,
              isFromDetails: false,
              onRefresh: () => _refresh(willBackground: true, isFromAction: true),
            ),
            onEditManualOrder: () => KlikitOrderResolver().editManualOrder(context, item),
            onEditGrabOrder: () => GrabOrderResolver().editGrabOrderOrder(
              context: context,
              order: item,
              onGrabEditSuccess: (order) => _refresh(willBackground: true),
            ),
            onRiderFind: () => KlikitOrderResolver().findRider(
              context: context,
              orderID: item.id,
              onRefresh: () => _refresh(willBackground: true),
            ),
            onSwitchRider: () {},
          );
        },
        firstPageProgressIndicatorBuilder: getFirstPageProgressIndicator,
        newPageProgressIndicatorBuilder: getNewPageProgressIndicator,
        noItemsFoundIndicatorBuilder: noItemsFoundIndicator,
        newPageErrorIndicatorBuilder: (_) => getPageErrorIndicator(() => _refresh()),
        firstPageErrorIndicatorBuilder: (_) => getPageErrorIndicator(() => _refresh()),
      ),
      separatorBuilder: (BuildContext context, int index) => AppSize.s8.verticalSpacer(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pagingController?.dispose();
    widget.oniFilterManager.removeObserver(ObserverTag.NEW_ORDER);
    super.dispose();
  }

  @override
  void applyFilter(OniFilteredData? filteredData) {
    _filteredData = filteredData;
    _refresh();
  }
}
