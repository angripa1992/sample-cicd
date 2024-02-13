import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/payment_method_card.dart';
import 'package:klikit/modules/common/entities/payment_info.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class PaymentMethodSelector extends StatefulWidget {
  final List<PaymentMethod> methods;
  final int? initMethod;
  final int? initChannel;
  final Function(int?, int?) onChanged;

  const PaymentMethodSelector({super.key, required this.methods, required this.onChanged, this.initMethod, this.initChannel});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  late ExpandedTileController _controller;
  PaymentMethod? _method;
  PaymentChannel? _channel;

  @override
  void initState() {
    _controller = ExpandedTileController(isExpanded: false);
    if (widget.initMethod != null && widget.initChannel != null) {
      _method ??= widget.methods.firstWhere((element) => element.id == widget.initMethod);
      _channel ??= _method!.channels.firstWhere((element) => element.id == widget.initChannel);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 8.rh),
      child: Column(
        children: [
          ExpandedTile(
            theme: ExpandedTileThemeData(
              headerColor: AppColors.white,
              headerRadius: 0,
              headerPadding: EdgeInsets.zero,
              headerSplashColor: AppColors.greyDarker,
              contentBackgroundColor: AppColors.white,
              contentPadding: EdgeInsets.only(top: AppSize.s8.rh),
              contentRadius: 0,
              titlePadding: EdgeInsets.zero,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.black,
            ),
            trailingRotation: 180,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppStrings.add_payment_method.tr(),
                  style: semiBoldTextStyle(
                    fontSize: AppSize.s14.rSp,
                    color: AppColors.neutralB700,
                  ),
                ),
                AppSize.s12.horizontalSpacer(),
                KTChip(
                  text: AppStrings.optional.tr(),
                  textStyle: mediumTextStyle(fontSize: AppSize.s10.rSp, color: AppColors.neutralB700),
                  strokeColor: AppColors.neutralB40,
                  backgroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw, vertical: AppSize.s2.rh),
                )
              ],
            ),
            content: Visibility(
              visible: widget.methods.isNotEmpty,
              child: Column(
                children: widget.methods
                    .map(
                      (method) => PaymentMethodCard(
                        method: method,
                        selectedMethodId: _method?.id,
                        selectedChannelId: _channel?.id ?? _method?.channels.firstOrNull?.id,
                        onChanged: (method, channel) {
                          setState(() {
                            _method = method;
                            _channel = channel;
                            widget.onChanged(method.id, channel?.id);
                          });
                        },
                      ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s8),
                    )
                    .toList(),
              ),
            ),
            controller: _controller,
          )
        ],
      ),
    );
  }
}
