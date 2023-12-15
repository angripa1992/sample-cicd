import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/presentation/components/details/pickup_time_view.dart';
import 'package:klikit/modules/orders/presentation/components/details/preparation_time_view.dart';
import 'package:klikit/modules/orders/presentation/components/details/price_view.dart';
import 'package:klikit/modules/orders/presentation/components/details/rider_action_view.dart';
import 'package:klikit/modules/orders/presentation/components/details/rider_info_view.dart';
import 'package:klikit/modules/orders/presentation/components/details/scheduled_view.dart';
import 'package:klikit/modules/orders/utils/grab_order_resolver.dart';
import 'package:klikit/modules/orders/utils/klikit_order_resolver.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/values.dart';
import 'cancellation_reason.dart';
import 'comment_view.dart';
import 'customer_info_view.dart';
import 'delivery_address_view.dart';
import 'order_details_header.dart';
import 'order_item_details.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  final Widget actionView;
  final VoidCallback onEditManualOrder;
  final VoidCallback onRiderFind;
  final VoidCallback onRefresh;

  const OrderDetailsScreen({
    Key? key,
    required this.order,
    required this.actionView,
    required this.onEditManualOrder,
    required this.onRiderFind,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Order _currentOrder;

  void _editGrabOrder() {
    GrabOrderResolver().editGrabOrderOrder(
      context: context,
      order: _currentOrder,
      onGrabEditSuccess: (order) {
        widget.onRefresh();
        setState(() {
          _currentOrder = order;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.order_details.tr()),
        ),
        body: FutureBuilder<Order?>(
          future: getIt.get<OrderRepository>().fetchOrderById(widget.order.id),
          builder: (_, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              _currentOrder = snapshot.data!;
              return _body();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _body() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_currentOrder.status == OrderStatus.SCHEDULED && _currentOrder.scheduledTime.isNotEmpty)
                    ScheduledDetailsView(
                      scheduleTime: _currentOrder.scheduledTime,
                    ),
                  OrderDetailsHeaderView(
                    order: _currentOrder,
                    onCommentActionSuccess: widget.onRefresh,
                    onEditGrabOrder: _editGrabOrder,
                    onEditManualOrder: widget.onEditManualOrder,
                    onSwitchRider: () {
                      KlikitOrderResolver().cancelRider(
                        context: context,
                        order: _currentOrder,
                        onSuccess: () {
                          Navigator.pop(context);
                          widget.onRefresh();
                        },
                      );
                    },
                  ),
                  RiderActionView(order: _currentOrder, onRiderFind: widget.onRiderFind),
                  PrepTimeView(
                    order: _currentOrder,
                    onUpdateSuccess: (min) {
                      setState(() {
                        _currentOrder.preparationTime = min;
                      });
                    },
                  ),
                  CancellationReasonView(order: _currentOrder),
                  OrderItemDetails(order: _currentOrder),
                  CommentView(comment: _currentOrder.orderComment),
                  RiderInfoView(order: _currentOrder),
                  OrderCustomerInfoView(order: _currentOrder),
                  PickupTimeView(order: _currentOrder),
                  DeliveryAddressView(order: _currentOrder),
                  PriceView(order: _currentOrder),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.s8.rh,
              horizontal: AppSize.s16.rw,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 0.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: widget.actionView,
          ),
        ],
      );
}
