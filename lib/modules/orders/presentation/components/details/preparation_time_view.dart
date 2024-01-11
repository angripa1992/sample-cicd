import 'package:docket_design_template/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/bloc/update_prep_time_cubit.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/di.dart';
import '../../../../../resources/styles.dart';

class PrepTimeView extends StatefulWidget {
  final Function(num) onUpdateSuccess;
  final Order order;

  const PrepTimeView({super.key, required this.order, required this.onUpdateSuccess});

  @override
  State<PrepTimeView> createState() => _PrepTimeViewState();
}

class _PrepTimeViewState extends State<PrepTimeView> {
  void _editPrepTime() {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (_) => getIt.get<UpdatePrepTimeCubit>(),
          child: AlertDialog(
            title: Row(
              children: [
                const Expanded(
                  child: Text('Edit meal preparation time'),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
            content: PrepTimeInputView(
              order: widget.order,
              onUpdateSuccess: widget.onUpdateSuccess,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.order.providerId == ProviderID.KLIKIT && widget.order.preparationTime > 0,
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s16.rw,
          vertical: AppSize.s8.rh,
        ),
        child: Row(
          children: [
            ImageResourceResolver.timerSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.neutralB80),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
                child: Text(
                  'Average meal preparation time will be',
                  style: regularTextStyle(
                    color: AppColors.neutralB500,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: KTButton(
                controller: KTButtonController(label: '${widget.order.preparationTime} Mins'),
                suffixWidget: ImageResourceResolver.editSVG.getImageWidget(width: AppSize.s14.rw, height: AppSize.s14.rh, color: AppColors.neutralB400),
                backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.greyBright),
                labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.neutralB700),
                splashColor: AppColors.greyBright,
                onTap: _editPrepTime,
              ),
            ),
          ],
        ),
      ).setVisibilityWithSpace(direction: Axis.vertical, startSpace: AppSize.s8),
    );
  }
}

class PrepTimeInputView extends StatefulWidget {
  final Function(num) onUpdateSuccess;
  final Order order;

  const PrepTimeInputView({super.key, required this.order, required this.onUpdateSuccess});

  @override
  State<PrepTimeInputView> createState() => _PrepTimeInputViewState();
}

class _PrepTimeInputViewState extends State<PrepTimeInputView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.order.preparationTime.toString();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _update() {
    if (_formKey.currentState!.validate()) {
      final min = num.parse(_controller.text);
      context.read<UpdatePrepTimeCubit>().updatePrepTime(
            orderID: widget.order.id,
            externalID: widget.order.externalId,
            min: min,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.greyDarker),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.greyDarker),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.greyDarker),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSize.s12.rw,
                      vertical: AppSize.ZERO,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter preparation time';
                    } else if (num.parse(value) < 1) {
                      return 'Min value must be more than 0';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: AppSize.s8.rw),
              Text(
                'Min',
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.s16.rh),
          BlocConsumer<UpdatePrepTimeCubit, ResponseState>(
            listener: (context, state) {
              if (state is Failed) {
                showApiErrorSnackBar(context, state.failure);
              } else if (state is Success<ActionSuccess>) {
                showSuccessSnackBar(context, state.data.message ?? '');
                Navigator.pop(context);
                widget.onUpdateSuccess(num.parse(_controller.text));
              }
            },
            builder: (context, state) {
              return LoadingButton(
                isLoading: state is Loading,
                onTap: () {
                  _update();
                },
                text: AppStrings.update.tr(),
              );
            },
          ),
        ],
      ),
    );
  }
}
