import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/presentation/bloc/schedule_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/components/progress_indicator.dart';
import 'package:klikit/modules/orders/provider/order_parameter_provider.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../printer/printing_handler.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../filter_observer.dart';
import '../filter_subject.dart';
import 'details/order_details_bottom_sheet.dart';
import 'order_item/order_item_view.dart';

class ScheduleOrderScreen extends StatefulWidget {
  final FilterSubject subject;

  const ScheduleOrderScreen({Key? key, required this.subject})
      : super(key: key);

  @override
  State<ScheduleOrderScreen> createState() => _ScheduleOrderScreenState();
}

class _ScheduleOrderScreenState extends State<ScheduleOrderScreen>
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

  PagingController<int, Order>? _pagingController;

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: _firstPageKey);
    filterSubject = widget.subject;
    filterSubject?.addObserver(this, ObserverTag.SCHEDULE_ORDER);
    _providers = filterSubject?.getProviders();
    _brands = filterSubject?.getBrands();
    _startTimer();
    _pagingController?.addPageRequestListener((pageKey) {
      _fetchScheduleOrder(pageKey);
    });
    super.initState();
  }

  void _fetchScheduleOrder(int pageKey) async {
    final params = await _orderParamProvider.getScheduleOrderParams(
      _brands,
      _providers,
      page: pageKey,
      pageSize: _pageSize,
    );
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
        _refreshScheduleOrderCount();
        _refresh(willBackground: true);
      },
    );
  }

  void _refreshScheduleOrderCount() {
    context.read<ScheduleOrderCubit>().fetchScheduleOrder(
          willShowLoading: false,
          providersID: _providers,
          brandsID: _brands,
        );
  }

  void _refresh({bool willBackground = false}) {
    _refreshScheduleOrderCount();
    if (willBackground) {
      _pagingController?.itemList?.clear();
      _pagingController?.notifyPageRequestListeners(_firstPageKey);
    } else {
      _pagingController?.refresh();
    }
  }

  void _onPrint({required Order order, required bool isFromDetails}) {
    _printingHandler.printDocket(
      order: order,
      isAutoPrint: order.status == OrderStatus.PLACED,
    );
    SegmentManager().trackOrderSegment(
      sourceTab: 'Schedule Order',
      isFromDetails: isFromDetails,
      willPrint: true,
    );
  }

  void _sendEvent() {
    SegmentManager().screen(
      event: SegmentEvents.SEE_DETAILS,
      name: 'See Details',
      properties: {'source_tab': 'Schedule Order'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Order>.separated(
      pagingController: _pagingController!,
      builderDelegate: PagedChildBuilderDelegate<Order>(
        itemBuilder: (context, item, index) {
          return OrderItemView(
            order: item,
            seeDetails: () {
              showOrderDetails(
                key: _modelScaffoldKey,
                context: context,
                order: item,
                onAction: (title, status) {},
                onPrint: () {
                  _onPrint(order: item, isFromDetails: true);
                },
                onCancel: (title) {},
                onCommentActionSuccess: () {
                  _refresh(willBackground: true);
                },
                onGrabEditSuccess: () {},
                onEditManualOrder: () {},
                onRiderFind: () {},
              );
              _sendEvent();
            },
            onPrint: () {
              _onPrint(order: item, isFromDetails: false);
            },
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
        newPageErrorIndicatorBuilder: (_) =>
            getPageErrorIndicator(() => _refresh()),
        firstPageErrorIndicatorBuilder: (_) =>
            getPageErrorIndicator(() => _refresh()),
      ),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
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

  @override
  void applyStatusFilter(List<int> status) {}
}
