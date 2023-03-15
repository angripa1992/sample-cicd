import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/orders/presentation/components/progress_indicator.dart';
import 'package:klikit/modules/orders/provider/order_parameter_provider.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../printer/printing_handler.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../domain/entities/order.dart';
import '../../domain/repository/orders_repository.dart';
import '../filter_observer.dart';
import '../filter_subject.dart';
import '../order_screen_navigate_data.dart';
import 'date_range_picker.dart';
import 'details/order_details_bottom_sheet.dart';
import 'order_item/history_order_item.dart';

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
  final _printingHandler = getIt.get<PrintingHandler>();
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
      pageSize: _pageSize,
    );
    params['page'] = pageKey;
    params['start'] = DateTimeProvider.getDate(_dateRange!.start);
    params['end'] =
        DateTimeProvider.getDate(_dateRange!.end.add(const Duration(days: 1)));
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

  void _onPrint({required Order order, required bool isFromDetails}) {
    _printingHandler.printDocket(order: order);
    SegmentManager().trackOrderSegment(
      sourceTab: 'Order History',
      isFromDetails: isFromDetails,
      willPrint: true,
    );
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

  void _sendEvent() {
    SegmentManager().screen(
      event: SegmentEvents.SEE_DETAILS,
      name: 'See Details',
      properties: {'source_tab': 'Order History'},
    );
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
          child: PagedListView<int, Order>(
            pagingController: _pagingController!,
            builderDelegate: PagedChildBuilderDelegate<Order>(
              itemBuilder: (context, item, index) {
                return HistoryOrderItemView(
                  order: item,
                  seeDetails: () {
                    showHistoryOrderDetails(
                      key: _modelScaffoldKey,
                      context: context,
                      order: item,
                      onCommentActionSuccess: () {
                        _refresh();
                      },
                      onPrint: () {
                        _onPrint(order: item, isFromDetails: true);
                      },
                    );
                    _sendEvent();
                  },
                  onPrint: () {
                    _onPrint(order: item, isFromDetails: false);
                  },
                );
              },
              firstPageProgressIndicatorBuilder: getFirstPageProgressIndicator,
              newPageProgressIndicatorBuilder: getNewPageProgressIndicator,
              noItemsFoundIndicatorBuilder: noItemsFoundIndicator,
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
