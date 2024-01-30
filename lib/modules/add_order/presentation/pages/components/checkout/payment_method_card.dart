import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_radio_group.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/checkout/payment_channel_selector.dart';
import 'package:klikit/modules/common/entities/payment_info.dart';
import 'package:klikit/modules/orders/presentation/components/dialogs/action_dialogs.dart';
import 'package:klikit/resources/asset_resolver/svg_image_resource.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final int? selectedMethodId;
  final int? selectedChannelId;
  final TextStyle? titleStyle;
  final Color? splashColor;
  final Function(PaymentMethod, PaymentChannel?) onChanged;

  const PaymentMethodCard({
    Key? key,
    required this.method,
    this.selectedMethodId,
    this.selectedChannelId,
    this.titleStyle,
    this.splashColor,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange(method.id, method.channels.first);
      },
      borderRadius: BorderRadius.circular(AppSize.s8.rSp),
      splashColor: splashColor,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh, horizontal: AppSize.s12.rw),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(width: 0.5.rSp, color: selectedMethodId == method.id ? AppColors.primaryP300 : AppColors.neutralB40),
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                prepareActionDecoration(
                  SVGImageResource(AppIcons.digitalWalletSVG)
                      .getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: selectedMethodId == method.id ? AppColors.primaryP300 : AppColors.neutralB100),
                  selectedMethodId == method.id ? AppColors.primaryP50 : AppColors.neutralB20,
                ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s12),
                Expanded(
                  child: Text(
                    method.title,
                    style: titleStyle ??
                        mediumTextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.s16.rSp,
                        ),
                  ),
                ),
                Radio<int>(
                  value: method.id,
                  groupValue: selectedMethodId,
                  activeColor: AppColors.primaryP300,
                  onChanged: (methodId) {
                    final channel = method.channels.firstOrNull;
                    onChange(method.id, channel);
                  },
                )
              ],
            ),
            if (method.channels.isNotEmpty)
              PaymentChannelSelector(
                values: method.channels.map((e) => KTRadioValue(e.id, e.title)).toList(),
                selectedChannelId: selectedChannelId,
                onChannelChanged: (value) {
                  final channel = method.channels.firstWhereOrNull((element) => element.id == value.id);
                  if (channel != null) {
                    onChange(method.id, channel);
                  }
                },
              )
          ],
        ),
      ),
    );
  }

  void onChange(int? methodId, PaymentChannel? channel) {
    onChanged(method, channel);
  }
}
