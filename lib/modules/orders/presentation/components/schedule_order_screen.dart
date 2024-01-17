import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/modules/common/oni_parameter_provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/presentation/components/progress_indicator.dart';
import 'package:klikit/modules/orders/utils/klikit_order_resolver.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../oni_filter_manager.dart';
import 'details/order_details_bottom_sheet.dart';
import 'order_item/order_item_view.dart';

class ScheduleOrderScreen extends StatefulWidget {
  final OniFilterManager oniFilterManager;

  const ScheduleOrderScreen({Key? key, required this.oniFilterManager}) : super(key: key);

  @override
  State<ScheduleOrderScreen> createState() => _ScheduleOrderScreenState();
}

class _ScheduleOrderScreenState extends State<ScheduleOrderScreen> with FilterObserver {
  final _orderRepository = getIt.get<OrderRepository>();
  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();
  final _sourceTab = 'Schedule Order';
  static const _pageSize = 10;
  static const _firstPageKey = 1;
  Timer? _timer;
  PagingController<int, Order>? _pagingController;
  OniFilteredData? _filteredData;

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: _firstPageKey);
    widget.oniFilterManager.addObserver(this, ObserverTag.SCHEDULE_ORDER);
    _filteredData = widget.oniFilterManager.filteredData();
    _startTimer();
    _pagingController?.addPageRequestListener((pageKey) {
      _fetchScheduleOrder(pageKey);
    });
    super.initState();
  }

  void _fetchScheduleOrder(int pageKey) async {
    final params = await OniParameterProvider().scheduleOrder(filteredData: _filteredData, page: pageKey, pageSize: _pageSize);
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

  void _refresh({bool willBackground = false}) {
    KlikitOrderResolver().refreshOrderCounts(context, filteredData: _filteredData);
    if (willBackground) {
      _pagingController?.itemList?.clear();
      _pagingController?.notifyPageRequestListeners(_firstPageKey);
    } else {
      _pagingController?.refresh();
    }
  }

  void _showDetails(Order item) {
    showOrderDetails(
      key: _modelScaffoldKey,
      context: context,
      order: item,
      onAction: (title, status) {},
      onPrint: () => KlikitOrderResolver().printDocket(
        order: item,
        isFromDetails: true,
        sourceTab: _sourceTab,
      ),
      onRefresh: () => _refresh(willBackground: true),
      onCancel: (title) {},
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
              isFromDetails: true,
              sourceTab: _sourceTab,
            ),
            onAction: (_, __) {},
            onCancel: (_) {},
            onEditGrabOrder: () {},
            onEditManualOrder: () {},
            onRiderFind: () {},
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
    widget.oniFilterManager.removeObserver(ObserverTag.SCHEDULE_ORDER);
    super.dispose();
  }

  @override
  void applyFilter(OniFilteredData? filteredData) {
    _filteredData = filteredData;
    _refresh();
  }
}
