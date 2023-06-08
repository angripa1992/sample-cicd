import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../domain/entities/add_to_cart_item.dart';
import '../cart/tag_title.dart';
import 'customer_into_field.dart';

class CustomerInfoView extends StatefulWidget {
  final CustomerInfo? initInfo;
  final Function(CustomerInfo) onCustomerInfoSave;

  const CustomerInfoView({Key? key, required this.onCustomerInfoSave, this.initInfo})
      : super(key: key);

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
    if(initInfo != null){
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
        children: [
          const TagTitleView(
            title: AppStrings.customer_info,
            required: false,
          ),
          const Divider(),
          ExpandedTile(
            theme: ExpandedTileThemeData(
              headerColor: AppColors.white,
              headerRadius: 0,
              headerPadding: EdgeInsets.zero,
              headerSplashColor: AppColors.dustyGreay,
              contentBackgroundColor: AppColors.white,
              contentPadding: EdgeInsets.only(top: AppSize.s8.rh),
              contentRadius: 0,
              titlePadding: EdgeInsets.zero,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.dustyGreay,
            ),
            trailingRotation: 180,
            title: Text(
              AppStrings.add_customer_info,
              style: getRegularTextStyle(
                color: AppColors.dustyGreay,
              ),
            ),
            content: Column(
              children: [
                CustomerInfoField(
                  title: AppStrings.first_name.tr(),
                  controller: _firstNameController,
                ),
                CustomerInfoField(
                  title: AppStrings.last_name.tr(),
                  controller: _lastNameController,
                ),
                CustomerInfoField(
                  title: AppStrings.email.tr(),
                  controller: _emailController,
                ),
                CustomerInfoField(
                  title: AppStrings.phone,
                  controller: _phoneController,
                ),
                CustomerInfoField(
                  title: AppStrings.table_no,
                  controller: _tableNoController,
                ),
                ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purpleBlue,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSize.s10.rh),
                    child: Text(
                      AppStrings.submit,
                      style: getMediumTextStyle(
                        color: AppColors.white,
                        fontSize: AppFontSize.s12.rSp,
                      ),
                    ),
                  ),
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
