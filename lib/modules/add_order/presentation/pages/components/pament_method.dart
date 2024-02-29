import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../common/business_information_provider.dart';
import '../../../../common/entities/payment_info.dart';
import 'cart/tag_title.dart';

class PaymentMethodView extends StatefulWidget {
  final Function(int?, int?) onChanged;
  final int? initMethod;
  final int? initChannel;
  final bool? required;
  final bool willShowReqTag;

  const PaymentMethodView({
    Key? key,
    required this.onChanged,
    this.initMethod,
    this.initChannel,
    this.willShowReqTag = true,
    this.required = false,
  }) : super(key: key);

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
        mainAxisSize: MainAxisSize.min,
        children: [
          TagTitleView(
            title: AppStrings.payment_method.tr(),
            required: widget.required!,
            willShowReqTag: widget.willShowReqTag,
          ),
          FutureBuilder<List<PaymentMethod>>(
            future: getIt.get<BusinessInformationProvider>().fetchPaymentMethods(),
            builder: (_, snap) {
              if (snap.hasData && snap.data?.isNotEmpty == true) {
                return PaymentMethodSelector(
                  methods: snap.data!,
                  onChanged: widget.onChanged,
                  initMethod: widget.initMethod,
                  initChannel: widget.initChannel,
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

class PaymentMethodSelector extends StatefulWidget {
  final List<PaymentMethod> methods;
  final int? initMethod;
  final int? initChannel;
  final Function(int?, int?) onChanged;

  const PaymentMethodSelector({
    Key? key,
    required this.methods,
    this.initMethod,
    this.initChannel,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  PaymentChannel? _channel;
  PaymentMethod? _method;

  @override
  void initState() {
    if (widget.initMethod != null && widget.initChannel != null) {
      _method = widget.methods.firstWhereOrNull((element) => element.id == widget.initMethod);
      _channel = _method?.channels.firstWhereOrNull((element) => element.id == widget.initChannel);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (dContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSize.s16.rSp),
                ),
              ),
              content: PaymentMethodDropdown(
                methods: widget.methods,
                initMethod: _method,
                initChannel: _channel,
                onChanged: (method, channel) {
                  setState(() {
                    _method = method;
                    _channel = channel;
                  });
                  widget.onChanged(_method?.id, _channel?.id);
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s10.rw,
          vertical: AppSize.s8.rh,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
          color: AppColors.grey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _channel == null ? AppStrings.add_payment_method.tr() : _channel!.title,
              style: regularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodDropdown extends StatefulWidget {
  final List<PaymentMethod> methods;
  final PaymentMethod? initMethod;
  final PaymentChannel? initChannel;
  final Function(PaymentMethod?, PaymentChannel?) onChanged;

  const PaymentMethodDropdown({
    Key? key,
    required this.methods,
    required this.onChanged,
    this.initMethod,
    this.initChannel,
  }) : super(key: key);

  @override
  State<PaymentMethodDropdown> createState() => _PaymentMethodDropdownState();
}

class _PaymentMethodDropdownState extends State<PaymentMethodDropdown> {
  PaymentChannel? _channel;
  PaymentMethod? _method;

  @override
  void initState() {
    _channel = widget.initChannel;
    _method = widget.initMethod;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.methods.map((method) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s8.rw,
                  vertical: AppSize.s4.rh,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s4.rSp),
                  color: AppColors.greyLight,
                ),
                child: Text(
                  method.title,
                  style: mediumTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s8.rw,
                  vertical: AppSize.s8.rh,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: method.channels.map((channel) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _method = method;
                          _channel = channel;
                        });
                        widget.onChanged(_method, _channel);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSize.s8.rh,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              channel.title,
                              style: regularTextStyle(
                                color: AppColors.black,
                                fontSize: AppFontSize.s14.rSp,
                              ),
                            ),
                            if (_method?.id == method.id && _channel?.id == channel.id) Icon(Icons.check, color: AppColors.primary),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          );
        }).toList(),
      ),
    );
  }
}
