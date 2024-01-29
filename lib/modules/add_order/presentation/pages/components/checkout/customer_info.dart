import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/core/widgets/labeled_textfield.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../resources/strings.dart';
import '../../../../domain/entities/add_to_cart_item.dart';

class CustomerInfoView extends StatefulWidget {
  final CustomerInfo? initInfo;
  final Function(CustomerInfo) onCustomerInfoSave;

  const CustomerInfoView({
    Key? key,
    required this.onCustomerInfoSave,
    this.initInfo,
  }) : super(key: key);

  @override
  State<CustomerInfoView> createState() => _CustomerInfoViewState();
}

class _CustomerInfoViewState extends State<CustomerInfoView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tableNoController = TextEditingController();
  late ExpandedTileController _controller;

  @override
  void initState() {
    final initInfo = widget.initInfo;
    if (initInfo != null) {
      _firstNameController.text = initInfo.firstName;
      _lastNameController.text = initInfo.lastName;
      _emailController.text = initInfo.email;
      _phoneController.text = initInfo.phone;
      _tableNoController.text = initInfo.tableNo;
    }
    _controller = ExpandedTileController(isExpanded: false);
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _tableNoController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSave() {
    final customerInfo = CustomerInfo(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      tableNo: _tableNoController.text,
    );
    _controller.toggle();
    widget.onCustomerInfoSave(customerInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s16.rh,
      ),
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
                  AppStrings.customer_info.tr(),
                  style: semiBoldTextStyle(
                    fontSize: AppSize.s16.rSp,
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
            content: Column(
              children: [
                LabeledTextField(
                  label: AppStrings.first_name.tr(),
                  textInputAction: TextInputAction.next,
                  controller: _firstNameController,
                  inputType: TextInputType.name,
                  inBetweenGap: AppSize.s6.rh,
                ),
                AppSize.s16.verticalSpacer(),
                LabeledTextField(
                  label: AppStrings.last_name.tr(),
                  textInputAction: TextInputAction.next,
                  controller: _lastNameController,
                  inputType: TextInputType.name,
                  inBetweenGap: AppSize.s6.rh,
                ),
                AppSize.s16.verticalSpacer(),
                LabeledTextField(
                  label: AppStrings.email.tr(),
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  inBetweenGap: AppSize.s6.rh,
                ),
                AppSize.s16.verticalSpacer(),
                LabeledTextField(
                  label: AppStrings.phone.tr(),
                  textInputAction: TextInputAction.next,
                  controller: _phoneController,
                  inputType: TextInputType.phone,
                  inBetweenGap: AppSize.s6.rh,
                ),
                AppSize.s16.verticalSpacer(),
                LabeledTextField(
                  label: AppStrings.table_no.tr(),
                  textInputAction: TextInputAction.done,
                  controller: _tableNoController,
                  inBetweenGap: AppSize.s6.rh,
                ),
                AppSize.s16.verticalSpacer(),
                KTButton(
                  controller: KTButtonController(label: AppStrings.submit.tr()),
                  backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.neutralB30),
                  labelStyle: mediumTextStyle(color: AppColors.neutralB700),
                  verticalContentPadding: 10.rh,
                  onTap: _onSave,
                ),
              ],
            ),
            controller: _controller,
          ),
        ],
      ),
    );
  }
}
