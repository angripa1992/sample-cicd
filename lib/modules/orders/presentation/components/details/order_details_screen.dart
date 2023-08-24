import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/details/price_view.dart';
import 'package:klikit/modules/orders/presentation/components/details/rider_info_view.dart';
import 'package:klikit/modules/orders/presentation/components/details/scheduled_view.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../edit_order/calculate_grab_order_cubit.dart';
import '../../../edit_order/edit_grab_order.dart';
import '../../../edit_order/update_grab_order_cubit.dart';
import 'cancellation_reason.dart';
import 'comment_view.dart';
import 'customer_info_view.dart';
import 'order_details_header.dart';
import 'order_item_details.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  final VoidCallback onCommentActionSuccess;
  final VoidCallback onGrabEditSuccess;
  final Widget actionView;
  final VoidCallback onEditManualOrder;
  final VoidCallback onRiderFind;

  const OrderDetailsScreen({
    Key? key,
    required this.order,
    required this.onCommentActionSuccess,
    required this.onGrabEditSuccess,
    required this.actionView,
    required this.onEditManualOrder,
    required this.onRiderFind,
  }) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Order _currentOrder;

  @override
  void initState() {
    _currentOrder = widget.order;
    super.initState();
  }

  void _editGrabOrderOrder(Order order) {
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
                  widget.onGrabEditSuccess();
                  setState(() {
                    _currentOrder = order;
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _appBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_currentOrder.status == OrderStatus.SCHEDULED &&
                    _currentOrder.scheduledTime.isNotEmpty)
                  ScheduledDetailsView(
                    scheduleTime: _currentOrder.scheduledTime,
                  ),
                OrderDetailsHeaderView(
                  order: _currentOrder,
                  onCommentActionSuccess: widget.onCommentActionSuccess,
                  onEditGrabOrder: () {
                    _editGrabOrderOrder(_currentOrder);
                  },
                  onEditManualOrder: widget.onEditManualOrder,
                  onRiderFind: widget.onRiderFind,
                ),
                if (_currentOrder.status == OrderStatus.CANCELLED)
                  CancellationReasonView(
                      cancellationReason: _currentOrder.cancellationReason),
                OrderItemDetails(order: _currentOrder),
                CommentView(comment: _currentOrder.orderComment),
                if (_currentOrder.isThreePlOrder &&
                    _currentOrder.fulfillmentRider != null)
                  RiderInfoView(
                    riderInfo: _currentOrder.fulfillmentRider!,
                    pickUpTime: _currentOrder.fulfillmentExpectedPickupTime,
                  ),
                if (_currentOrder.status != OrderStatus.CANCELLED &&
                    _currentOrder.status != OrderStatus.DELIVERED &&
                    _currentOrder.status != OrderStatus.PICKED_UP)
                  OrderCustomerInfoView(order: _currentOrder),
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

  Widget _appBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
            child: Text(
              AppStrings.order_details.tr(),
              style: mediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.clear,
              size: AppSize.s18.rSp,
              color: AppColors.black,
            ),
          )
        ],
      ),
    );
  }
}
