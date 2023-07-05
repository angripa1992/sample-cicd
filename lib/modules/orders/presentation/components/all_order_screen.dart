import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/presentation/components/progress_indicator.dart';
import 'package:klikit/modules/orders/provider/order_parameter_provider.dart';
import 'package:klikit/printer/printing_handler.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../app/size_config.dart';
import '../../../add_order/domain/entities/add_to_cart_item.dart';
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
import 'order_item/order_item_view.dart';

class AllOrderScreen extends StatefulWidget {
  final FilterSubject subject;

  const AllOrderScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> with FilterObserver {
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
    filterSubject?.addObserver(this, ObserverTag.ALL_ORDER);
    _providers = filterSubject?.getProviders();
    _brands = filterSubject?.getBrands();
    _startTimer();
    _pagingController?.addPageRequestListener((pageKey) {
      _fetchAllOrder(pageKey);
    });
    super.initState();
  }

  void _fetchAllOrder(int pageKey) async {
    final params = await _orderParameterProvider.getAllOrderParams(
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
        _refresh(willBackground: true);
      },
    );
  }

  void _refresh({bool willBackground = false, bool isFromAction = false}) {
    _refreshAllOrderCount();
    _refreshNewOrderCount();
    _refreshOngoingOrderCount();
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
    required int status,
    bool willCancel = false,
    bool isFromDetails = false,
  }) {
    showOrderActionDialog(
      params: _orderParameterProvider.getOrderActionParams(order, willCancel),
      context: context,
      onSuccess: () {
        _refresh(willBackground: true, isFromAction: true);
        if (isFromDetails) {
          Navigator.of(context).pop();
        }
        if (!willCancel && status == OrderStatus.ACCEPTED) {
          _printDocket(order: order, isFromDetails: isFromDetails);
        }
      },
      title: title,
    );
  }

  void _printDocket({required Order order, required bool isFromDetails}) {
    _printingHandler.printDocket(order: order);
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
      final cartItems = await getIt
          .get<UpdateManualOrderDataProvider>()
          .generateCartItem(order);
      CartManager().clear();
      for (var cartItem in cartItems) {
        await CartManager().addToCart(cartItem);
      }
      EasyLoading.dismiss();
      _setEditableInfo(order);
      _gotoCartScreen();
    } on Exception catch (error) {
      EasyLoading.dismiss();
    }
  }

  void _setEditableInfo(Order order) {
    final editInfo = CartInfo(
      type: order.type == ZERO ? OrderType.DINE_IN : order.type,
      source: order.source,
      discountType: order.discountTYpe,
      discountValue: order.discountValue,
      additionalFee: order.additionalFee / 100,
      deliveryFee: order.deliveryFee / 100,
    );
    final customerInfo = CustomerInfo(
      firstName: order.userFirstName,
      lastName: order.userLastName,
      email: order.userEmail,
      phone: order.userPhone,
      tableNo: order.tableNo,
    );
    final paymentInfo = PaymentInfo(
      paymentStatus: order.paymentStatus,
      paymentMethod: order.paymentMethod == ZERO
          ? PaymentMethodId.CASH
          : order.paymentMethod,
    );
    final updateCartInfo = UpdateCartInfo(
      id: order.id,
      externalId: order.externalId,
      identity: order.identity,
    );
    CartManager().setCustomerInfo(customerInfo);
    CartManager().setEditInfo(editInfo);
    CartManager().setPaymentInfo(paymentInfo);
    CartManager().setUpdateCartInfo(updateCartInfo);
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
                  _onAction(
                    title: title,
                    order: item,
                    isFromDetails: true,
                    willCancel: true,
                    status: OrderStatus.CANCELLED,
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
              _onAction(
                title: title,
                order: item,
                willCancel: true,
                status: OrderStatus.CANCELLED,
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
