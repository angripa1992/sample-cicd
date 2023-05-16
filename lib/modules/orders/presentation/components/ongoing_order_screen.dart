import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/presentation/components/progress_indicator.dart';
import 'package:klikit/modules/orders/provider/order_parameter_provider.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../printer/printing_handler.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../bloc/ongoing_order_cubit.dart';
import '../filter_observer.dart';
import '../filter_subject.dart';
import 'details/order_details_bottom_sheet.dart';
import 'dialogs/action_dialogs.dart';
import 'dialogs/add_payment_method_and_status.dart';
import 'order_item/ongoing_order_item.dart';

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
    filterSubject?.addObserver(this, ObserverTag.ONGOING_ORDER);
    _providers = filterSubject?.getProviders();
    _brands = filterSubject?.getBrands();
    _startTimer();
    _pagingController?.addPageRequestListener((pageKey) {
      _fetchOngoingOrder(pageKey);
    });
    super.initState();
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
        _refreshOngoingOrderCount();
        _refresh(willBackground: true);
      },
    );
  }

  void _refreshOngoingOrderCount() {
    context.read<OngoingOrderCubit>().fetchOngoingOrder(
          willShowLoading: false,
          providersID: _providers,
          brandsID: _brands,
        );
  }

  void _refresh({bool willBackground = false}) {
    _refreshOngoingOrderCount();
    if (willBackground) {
      _pagingController?.itemList?.clear();
      _pagingController?.notifyPageRequestListeners(_firstPageKey);
    } else {
      _pagingController?.refresh();
    }
  }

  void _onActionSuccess(bool isFromDetails, int status) {
    _refresh(willBackground: true);
    if (isFromDetails) {
      Navigator.of(context).pop();
    }
    SegmentManager().trackOrderSegment(
      sourceTab: 'Ready Order',
      status: status,
      isFromDetails: isFromDetails,
    );
  }

  void _onAction({
    required String title,
    required Order order,
    required int status,
    bool willCancel = false,
    bool isFromDetails = false,
  }) {
    if (status == OrderStatus.DELIVERED &&
        (order.paymentStatus == PaymentStatusId.pending || order.paymentStatus == PaymentStatusId.failed)) {
      showAddPaymentStatusMethodDialog(
        title: 'Select payment method and status',
        context: context,
        order: order,
        willOnlyUpdatePaymentInfo: false,
        onSuccess: (method,status) {
          _onActionSuccess(isFromDetails, status);
        },
      );
    } else {
      showOrderActionDialog(
        params: _orderParamProvider.getOrderActionParams(order, willCancel),
        context: context,
        onSuccess: () {
          _onActionSuccess(isFromDetails, status);
        },
        title: title,
      );
    }
  }

  void _onPrint({required Order order, required bool isFromDetails}) {
    _printingHandler.printDocket(order: order);
    SegmentManager().trackOrderSegment(
      sourceTab: 'Ready Order',
      isFromDetails: isFromDetails,
      willPrint: true,
    );
  }

  void _sendEvent() {
    SegmentManager().screen(
      event: SegmentEvents.SEE_DETAILS,
      name: 'See Details',
      properties: {'source_tab': 'Ready Order'},
    );
  }

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
                key: _modelScaffoldKey,
                context: context,
                order: item,
                onAction: (title, status) {
                  _onAction(
                    title: title,
                    order: item,
                    status: status,
                    isFromDetails: true,
                  );
                },
                onPrint: () {
                  _onPrint(order: item, isFromDetails: true);
                },
                onCancel: (title) {
                  _onAction(
                    title: title,
                    order: item,
                    status: OrderStatus.CANCELLED,
                    isFromDetails: true,
                    willCancel: true,
                  );
                },
                onCommentActionSuccess: () {
                  _refresh(willBackground: true);
                },
              );
              _sendEvent();
            },
            onAction: (title, status) {
              _onAction(
                title: title,
                status: status,
                order: item,
              );
            },
            onPrint: () {
              _onPrint(order: item, isFromDetails: false);
            },
            onCancel: (title) {
              _onAction(
                title: title,
                order: item,
                willCancel: true,
                status: OrderStatus.CANCELLED,
              );
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
