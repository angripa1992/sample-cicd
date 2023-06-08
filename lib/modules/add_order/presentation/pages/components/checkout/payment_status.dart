import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../orders/domain/entities/payment_info.dart';
import '../../../../../orders/provider/order_information_provider.dart';
import '../cart/tag_title.dart';

class PaymentStatusView extends StatefulWidget {
  final Function(int) onChanged;
  final int? initStatus;
  final bool willShowReqTag;

  const PaymentStatusView({Key? key, required this.onChanged, this.initStatus,this.willShowReqTag = true})
      : super(key: key);

  @override
  State<PaymentStatusView> createState() => _PaymentStatusViewState();
}

class _PaymentStatusViewState extends State<PaymentStatusView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSize.s10.rw,
        vertical: AppSize.s10.rh,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s8.rw,
        vertical: AppSize.s8.rh,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TagTitleView(
            title: AppStrings.payment_status,
            required: true,
            willShowReqTag: widget.willShowReqTag,
          ),
          FutureBuilder<List<PaymentStatus>>(
            future: getIt.get<OrderInformationProvider>().fetchPaymentStatues(),
            builder: (_, snap) {
              if (snap.hasData) {
                return PaymentStatusDropdown(
                  statues: snap.data!,
                  onChanged: widget.onChanged,
                  initStatus: widget.initStatus,
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }
}

class PaymentStatusDropdown extends StatefulWidget {
  final List<PaymentStatus> statues;
  final Function(int) onChanged;
  final int? initStatus;

  const PaymentStatusDropdown(
      {Key? key, required this.statues, required this.onChanged, this.initStatus})
      : super(key: key);

  @override
  State<PaymentStatusDropdown> createState() => _PaymentStatusDropdownState();
}

class _PaymentStatusDropdownState extends State<PaymentStatusDropdown> {
  PaymentStatus? _paymentStatus;
  final _textStyle = getRegularTextStyle(
    color: AppColors.balticSea,
    fontSize: AppFontSize.s13.rSp,
  );

  @override
  void initState() {
   _paymentStatus = widget.statues.firstWhere((element) => element.id == (widget.initStatus ?? PaymentStatusId.pending));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSize.s8.rh),
      padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.whiteSmoke,
      ),
      child: DropdownButton<PaymentStatus>(
        isExpanded: true,
        value: _paymentStatus,
        underline: const SizedBox(),
        hint: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            AppStrings.select_payment_status,
            style: _textStyle,
          ),
        ),
        items: widget.statues
            .map<DropdownMenuItem<PaymentStatus>>((PaymentStatus value) {
          return DropdownMenuItem<PaymentStatus>(
              value: value,
              child: ListTile(
                tileColor: (_paymentStatus != null && _paymentStatus!.id == value.id) ? AppColors.alabaster : AppColors.white,
                title: Text(
                  value.title,
                  style: _textStyle,
                ),
                trailing:
                    (_paymentStatus != null && _paymentStatus!.id == value.id)
                        ? Icon(
                            Icons.check,
                            size: AppSize.s18.rSp,
                            color: AppColors.purpleBlue,
                          )
                        : const SizedBox(),
              ));
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return widget.statues.map<Widget>((PaymentStatus item) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                item.title,
                style: _textStyle,
              ),
            );
          }).toList();
        },
        onChanged: (value) {
          setState(() {
            _paymentStatus = value;
            widget.onChanged(_paymentStatus!.id);
          });
        },
      ),
    );
  }
}
