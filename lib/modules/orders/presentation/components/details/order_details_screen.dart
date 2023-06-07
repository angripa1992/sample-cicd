import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/details/price_view.dart';
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
import 'comment_view.dart';
import 'order_details_header.dart';
import 'order_item_details.dart';
import 'order_payment_info.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  final VoidCallback onCommentActionSuccess;
  final VoidCallback onGrabEditSuccess;
  final Widget actionView;
  final VoidCallback onEditManualOrder;

  const OrderDetailsScreen(
      {Key? key,
      required this.order,
      required this.onCommentActionSuccess,
      required this.onGrabEditSuccess,
      required this.actionView,
      required this.onEditManualOrder})
      : super(key: key);

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
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _appBar(),
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
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          child: Divider(color: AppColors.frenchGrey),
        ),
        OrderPaymentInfoView(order: _currentOrder),
        OrderItemDetails(order: _currentOrder),
        CommentView(comment: _currentOrder.orderComment),
        PriceView(order: _currentOrder),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.s8.rh,
            horizontal: AppSize.s16.rw,
          ),
          child: widget.actionView,
        ),
      ],
    );
  }

  Widget _appBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
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
              style: getMediumTextStyle(
                color: AppColors.balticSea,
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
              color: AppColors.blackCow,
            ),
          )
        ],
      ),
    );
  }
}
