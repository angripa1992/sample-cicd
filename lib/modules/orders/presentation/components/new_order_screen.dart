import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/presentation/components/progress_indicator.dart';
import 'package:klikit/modules/orders/provider/order_parameter_provider.dart';
import 'package:klikit/printer/printing_handler.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../../app/size_config.dart';
import '../../../add_order/presentation/pages/add_order_screen.dart';
import '../../../widgets/snackbars.dart';
import '../../edit_order/calculate_grab_order_cubit.dart';
import '../../edit_order/edit_grab_order.dart';
import '../../edit_order/update_grab_order_cubit.dart';
import '../../provider/update_manual_order_data_provider.dart';
import '../bloc/all_order_cubit.dart';
import '../bloc/new_order_cubit.dart';
import '../bloc/ongoing_order_cubit.dart';
import '../filter_observer.dart';
import '../filter_subject.dart';
import 'details/order_details_bottom_sheet.dart';
import 'dialogs/action_dialogs.dart';
import 'dialogs/cancellation_reason.dart';
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
    filterSubject?.addObserver(this, ObserverTag.NEW_ORDER);
    _providers = filterSubject?.getProviders();
    _brands = filterSubject?.getBrands();
    _startTimer();
    _pagingController?.addPageRequestListener((pageKey) {
      _fetchNewOrder(pageKey);
    });
    super.initState();
  }

  void _fetchNewOrder(int pageKey) async {
    final params = await _orderParameterProvider.getNewOrderParams(
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

  void _refreshAllOrderCount() {
    context.read<AllOrderCubit>().fetchAllOrder(
          providersID: _providers,
          brandsID: _brands,
        );
  }

  void _refreshNewOrderCount() {
    context.read<NewOrderCubit>().fetchNewOrder(
          willShowLoading: false,
          providersID: _providers,
          brandsID: _brands,
        );
  }

  void _refreshOngoingOrderCount() {
    context.read<OngoingOrderCubit>().fetchOngoingOrder(
          willShowLoading: false,
          providersID: _providers,
          brandsID: _brands,
        );
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: AppConstant.refreshTime),
      (timer) {
        _refreshNewOrderCount();
        _refresh(willBackground: true);
      },
    );
  }

  void _refresh({bool willBackground = false, bool isFromAction = false}) {
    _refreshNewOrderCount();
    if (isFromAction) {
      _refreshAllOrderCount();
      _refreshOngoingOrderCount();
    }
    if (willBackground) {
      _pagingController?.itemList?.clear();
      _pagingController?.notifyPageRequestListeners(_firstPageKey);
    } else {
      _pagingController?.refresh();
    }
  }

  void _cancelOrder({
    required String title,
    required Order order,
    required bool isFromDetails,
  }) {
    showCancellationReasonDialog(
        context: context,
        title: title,
        order: order,
        successCallback: () {
          _refresh(willBackground: true, isFromAction: true);
          if (isFromDetails) {
            Navigator.of(context).pop();
          }
          SegmentManager().trackOrderSegment(
            sourceTab: 'New Order',
            status: OrderStatus.CANCELLED,
            isFromDetails: isFromDetails,
          );
        });
  }

  void _onAction({
    required String title,
    required Order order,
    required int status,
    bool isFromDetails = false,
  }) {
    showOrderActionDialog(
      params: _orderParameterProvider.getOrderActionParams(order),
      context: context,
      title: title,
      onSuccess: () {
        _refresh(willBackground: true, isFromAction: true);
        if (isFromDetails) {
          Navigator.of(context).pop();
        }
        if (status == OrderStatus.ACCEPTED) {
          _printDocket(order: order, isFromDetails: isFromDetails);
        }
        SegmentManager().trackOrderSegment(
          sourceTab: 'New Order',
          status: status,
          isFromDetails: isFromDetails,
        );
      },
    );
  }

  void _printDocket({required Order order, required bool isFromDetails}) {
    _printingHandler.printDocket(
      order: order,
      isAutoPrint: order.status == OrderStatus.PLACED,
    );
    SegmentManager().trackOrderSegment(
      sourceTab: 'New Order',
      isFromDetails: isFromDetails,
      willPrint: true,
    );
  }

  void _sendScreenEvent() {
    SegmentManager().screen(
      event: SegmentEvents.SEE_DETAILS,
      name: 'See Details',
      properties: {'source_tab': 'New Order'},
    );
  }

  void _editGrabOrder(Order order) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<CalculateGrabBillCubit>(create: (_) => getIt.get()),
            BlocProvider<UpdateGrabOrderCubit>(create: (_) => getIt.get()),
          ],
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            extendBody: false,
            body: Container(
              margin: EdgeInsets.only(top: ScreenSizes.statusBarHeight),
              child: EditGrabOrderView(
                order: order,
                onClose: () {
                  Navigator.pop(context);
                },
                onEditSuccess: (Order order) {
                  _refresh(willBackground: true);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _editManualOrder(Order order) async {
    try {
      EasyLoading.show();
      await getIt.get<UpdateManualOrderDataProvider>().generateCartData(order);
      EasyLoading.dismiss();
      _gotoCartScreen();
    } on Exception catch (error) {
      EasyLoading.dismiss();
    }
  }

  void _gotoCartScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddOrderScreen(
          willOpenCart: true,
          willUpdateCart: true,
        ),
      ),
    );
  }

  void _findRider(int id) async {
    EasyLoading.show();
    final response = await _orderRepository.findRider(id);
    response.fold(
      (error) {
        EasyLoading.dismiss();
        showApiErrorSnackBar(context, error);
      },
      (success) {
        EasyLoading.dismiss();
        showSuccessSnackBar(context, success.message ?? '');
        _refresh(willBackground: true);
      },
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
                onAction: (title, status) {
                  _onAction(
                    title: title,
                    order: item,
                    isFromDetails: true,
                    status: status,
                  );
                },
                onPrint: () {
                  _printDocket(order: item, isFromDetails: true);
                },
                onCancel: (title) {
                  _cancelOrder(
                    title: title,
                    order: item,
                    isFromDetails: true,
                  );
                },
                onCommentActionSuccess: () {
                  _refresh(willBackground: true);
                },
                onGrabEditSuccess: () {
                  _refresh(willBackground: true);
                },
                onEditManualOrder: () {
                  Navigator.pop(context);
                  _editManualOrder(item);
                },
                onRiderFind: () {
                  _findRider(item.id);
                },
              );
              _sendScreenEvent();
            },
            onAction: (title, status) {
              _onAction(
                title: title,
                order: item,
                status: status,
              );
            },
            onPrint: () {
              _printDocket(order: item, isFromDetails: false);
            },
            onCancel: (title) {
              _cancelOrder(
                title: title,
                order: item,
                isFromDetails: false,
              );
            },
            onEditManualOrder: () {
              _editManualOrder(item);
            },
            onEditGrabOrder: () {
              _editGrabOrder(item);
            },
            onRiderFind: () {
              _findRider(item.id);
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
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pagingController?.dispose();
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

  @override
  void applyStatusFilter(List<int> status) {}
}
