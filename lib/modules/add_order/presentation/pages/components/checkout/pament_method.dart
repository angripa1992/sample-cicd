import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../orders/domain/entities/payment_info.dart';
import '../../../../../orders/provider/order_information_provider.dart';
import '../cart/tag_title.dart';

class PaymentMethodView extends StatefulWidget {
  final Function(PaymentMethod?) onChanged;

  const PaymentMethodView({Key? key, required this.onChanged})
      : super(key: key);

  @override
  State<PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
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
          const TagTitleView(
            title: 'Payment Method',
            required: false,
          ),
          FutureBuilder<List<PaymentMethod>>(
            future: getIt.get<OrderInformationProvider>().fetchPaymentMethods(),
            builder: (_, snap) {
              if (snap.hasData) {
                return PaymentMethodDropdown(
                  statues: snap.data!,
                  onChanged: widget.onChanged,
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

class PaymentMethodDropdown extends StatefulWidget {
  final List<PaymentMethod> statues;
  final Function(PaymentMethod?) onChanged;

  const PaymentMethodDropdown(
      {Key? key, required this.statues, required this.onChanged})
      : super(key: key);

  @override
  State<PaymentMethodDropdown> createState() => _PaymentMethodDropdownState();
}

class _PaymentMethodDropdownState extends State<PaymentMethodDropdown> {
  PaymentMethod? _paymentMethod;
  final _textStyle = getRegularTextStyle(
    color: AppColors.balticSea,
    fontSize: AppFontSize.s13.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSize.s8.rh),
      padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.whiteSmoke,
      ),
      child: DropdownButton<PaymentMethod>(
        isExpanded: true,
        value: _paymentMethod,
        underline: const SizedBox(),
        hint: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Add payment method',
            style: _textStyle,
          ),
        ),
        items: widget.statues
            .map<DropdownMenuItem<PaymentMethod>>((PaymentMethod value) {
          return DropdownMenuItem<PaymentMethod>(
              value: value,
              child: ListTile(
                title: Text(
                  value.title,
                  style: _textStyle,
                ),
                trailing:
                (_paymentMethod != null && _paymentMethod!.id == value.id)
                    ? Icon(
                  Icons.check,
                  size: AppSize.s18.rSp,
                  color: AppColors.balticSea,
                )
                    : const SizedBox(),
              ));
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return widget.statues.map<Widget>((PaymentMethod item) {
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
            if(_paymentMethod != null && _paymentMethod?.id == value?.id){
              _paymentMethod = null;
            }else{
              _paymentMethod = value;
            }
            widget.onChanged(_paymentMethod);
          });
        },
      ),
    );
  }
}
