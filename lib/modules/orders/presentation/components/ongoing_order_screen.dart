import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/common/order_parameter_provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/presentation/components/progress_indicator.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../utils/klikit_order_resolver.dart';
import '../filter_observer.dart';
import '../filter_subject.dart';
import 'details/order_details_bottom_sheet.dart';
import 'order_item/order_item_view.dart';

class OngoingOrderScreen extends StatefulWidget {
  final FilterSubject subject;

  const OngoingOrderScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<OngoingOrderScreen> createState() => _OngoingOrderScreenState();
}

class _OngoingOrderScreenState extends State<OngoingOrderScreen> with FilterObserver {
  final _orderRepository = getIt.get<OrderRepository>();
  final _orderParamProvider = getIt.get<OrderParameterProvider>();
  final _sourceTab = 'Ready';
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
        _refresh(willBackground: true);
      },
    );
  }

  void _refresh({bool willBackground = false}) {
    KlikitOrderResolver().refreshOrderCounts(context, providers: _providers, brands: _brands);
    if (willBackground) {
      _pagingController?.itemList?.clear();
      _pagingController?.notifyPageRequestListeners(_firstPageKey);
    } else {
      _pagingController?.refresh();
    }
  }

  // void _onActionSuccess(bool isFromDetails, int status) {
  //   _refresh(willBackground: true);
  //   if (isFromDetails) {
  //     Navigator.of(context).pop();
  //   }
  //   SegmentManager().trackOrderSegment(
  //     sourceTab: 'Ready Order',
  //     status: status,
  //     isFromDetails: isFromDetails,
  //   );
  // }

  // void _onAction({
  //   required String title,
  //   required Order order,
  //   required int status,
  //   bool willCancel = false,
  //   bool isFromDetails = false,
  // }) {
  //   if (status == OrderStatus.DELIVERED && order.isManualOrder && order.paymentStatus != PaymentStatusId.paid) {
  //     showAddPaymentStatusMethodDialog(
  //       title: AppStrings.select_payment_method_and_status.tr(),
  //       context: context,
  //       order: order,
  //       isWebShopPostPayment: false,
  //       onSuccess: (method, channel, status) {
  //         _onActionSuccess(isFromDetails, status);
  //       },
  //     );
  //   } else {
  //     showOrderActionDialog(
  //       params: _orderParamProvider.getOrderActionParams(order),
  //       context: context,
  //       onSuccess: () {
  //         _onActionSuccess(isFromDetails, status);
  //       },
  //       title: title,
  //     );
  //   }
  // }

  void _showDetails(Order item) {
    showOrderDetails(
      key: _modelScaffoldKey,
      context: context,
      order: item,
      onAction: (title, status) => KlikitOrderResolver().onAction(
        title: title,
        order: item,
        status: status,
        isFromDetails: true,
        context: context,
        sourceTab: _sourceTab,
        onRefresh: () => _refresh(willBackground: true),
      ),
      onPrint: () => KlikitOrderResolver().printDocket(
        order: item,
        isFromDetails: true,
        sourceTab: _sourceTab,
      ),
      onCancel: (title) => KlikitOrderResolver().cancelOrder(
        title: title,
        order: item,
        isFromDetails: true,
        context: context,
        sourceTab: _sourceTab,
        onRefresh: () => _refresh(willBackground: true),
      ),
      onRiderFind: () => KlikitOrderResolver().findRider(
        context: context,
        orderID: item.id,
        onRefresh: () => _refresh(willBackground: true),
      ),
      onRefresh: () => _refresh(willBackground: true),
      onEditManualOrder: () {},
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
            onAction: (title, status) => KlikitOrderResolver().onAction(
              title: title,
              status: status,
              order: item,
              context: context,
              sourceTab: _sourceTab,
              onRefresh: () => _refresh(willBackground: true),
            ),
            onPrint: () => KlikitOrderResolver().printDocket(
              order: item,
              isFromDetails: false,
              sourceTab: _sourceTab,
            ),
            onCancel: (title) => KlikitOrderResolver().cancelOrder(
              title: title,
              order: item,
              context: context,
              sourceTab: _sourceTab,
              onRefresh: () => _refresh(willBackground: true),
              isFromDetails: false,
            ),
            onRiderFind: () => KlikitOrderResolver().findRider(
              context: context,
              orderID: item.id,
              onRefresh: () => _refresh(willBackground: true),
            ),
            onSwitchRider: () {},
            onEditGrabOrder: () {},
            onEditManualOrder: () {},
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
