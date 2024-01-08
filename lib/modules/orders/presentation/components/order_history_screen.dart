import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/common/order_parameter_provider.dart';
import 'package:klikit/modules/orders/presentation/components/progress_indicator.dart';
import 'package:klikit/modules/orders/utils/klikit_order_resolver.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../domain/entities/order.dart';
import '../../domain/repository/orders_repository.dart';
import '../filter_observer.dart';
import '../filter_subject.dart';
import '../order_screen_navigate_data.dart';
import 'date_range_picker.dart';
import 'details/order_details_bottom_sheet.dart';
import 'order_item/order_item_view.dart';

class OrderHistoryScreen extends StatefulWidget {
  final FilterSubject subject;

  const OrderHistoryScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with FilterObserver {
  final _orderRepository = getIt.get<OrderRepository>();
  final _orderParamProvider = getIt.get<OrderParameterProvider>();
  final _sourceTab = 'Order History';
  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();
  static const _pageSize = 10;
  static const _firstPageKey = 1;
  Timer? _timer;
  List<int>? _providers;
  List<int>? _brands;
  List<int>? _status;
  PagingController<int, Order>? _pagingController;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: _firstPageKey);
    _initDatRange();
    filterSubject = widget.subject;
    filterSubject?.addObserver(this, ObserverTag.ORDER_HISTORY);
    _providers = filterSubject?.getProviders();
    _brands = filterSubject?.getBrands();
    _status = widget.subject.getStatus();
    _pagingController?.addPageRequestListener((pageKey) {
      _fetchOrderHistory(pageKey);
    });
    super.initState();
  }

  void _fetchOrderHistory(int pageKey) async {
    final params = await _orderParamProvider.getOrderHistoryParam(
      brandsID: _brands,
      providersID: _providers,
      status: _status,
      page: pageKey,
      pageSize: _pageSize,
    );
    params['start'] = DateTimeProvider.getDate(_dateRange!.start);
    params['end'] = DateTimeProvider.getDate(_dateRange!.end.add(const Duration(days: 1)));
    params['timezone'] = await DateTimeProvider.timeZone();
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

  void _initDatRange() {
    final navData = OrderScreenNavigateDataHandler().getData();
    if (navData == null) {
      _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
    } else {
      _dateRange = navData[HistoryNavData.HISTORY_NAV_DATA];
      OrderScreenNavigateDataHandler().clearData();
    }
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
    return Column(
      children: [
        Center(
          child: DateSelector(
            dateTimeRange: _dateRange!,
            onPick: (dateRange) {
              _dateRange = dateRange;
              _refresh();
            },
          ),
        ),
        SizedBox(height: AppSize.s16.rh),
        Flexible(
          child: PagedListView<int, Order>.separated(
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
            separatorBuilder: (BuildContext context, int index) => AppSize.s8.verticalSpacer(),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pagingController?.dispose();
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

  @override
  void applyStatusFilter(List<int> status) {
    _status = status;
    _refresh();
  }
}
