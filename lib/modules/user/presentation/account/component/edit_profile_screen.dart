import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/labeled_textfield.dart';
import 'package:klikit/modules/user/data/request_model/user_update_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/modules/user/domain/usecases/update_user_info.dart';
import 'package:klikit/modules/user/presentation/account/cubit/update_user_info_cubit.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/session_manager.dart';
import '../../../../widgets/dialogs.dart';
import '../../../../widgets/snackbars.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNameController = TextEditingController();
  final _emailNameController = TextEditingController();
  final _updateButtonController = KTButtonController(label: AppStrings.update.tr());
  final _formKey = GlobalKey<FormState>();
  late UserInfo _user;

  @override
  void initState() {
    _user = SessionManager().user()!;
    _firstNameController.text = _user.firstName;
    _lastNameController.text = _user.lastName;
    _phoneNameController.text = _user.phone;
    _emailNameController.text = _user.email;
    super.initState();
  }

  void _validateAndUpdate(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      bool isSameFirstName = _firstNameController.text == _user.firstName;
      bool isSameLastName = _lastNameController.text == _user.lastName;
      bool isSamePhone = _phoneNameController.text == _user.phone;
      if (isSameFirstName && isSameLastName && isSamePhone) {
        showValidationDialog(
          context: context,
          title: AppStrings.invalid_information.tr(),
          message: AppStrings.same_value_validation_message.tr(),
          onOK: () {},
        );
      } else {
        context.read<UpdateUserInfoCubit>().updateUserInfo(
              UpdateUserInfoParams(
                UserUpdateRequestModel(
                  branchId: _user.brandIDs.firstOrNull,
                  businessId: _user.businessId,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  phone: _phoneNameController.text,
                  roleIds: _user.roleIds,
                  countryIds: _user.countryIds,
                ),
                _user.id,
              ),
            );
      }
    }
  }

  void _saveUpdatedUserInfo() async {
    await SessionManager().saveUser(
      _user.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneNameController.text,
      ),
    );
    setState(() {
      _user = SessionManager().user()!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<UpdateUserInfoCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.edit_profile.tr()),
        ),
        body: Builder(
          builder: (context) => SingleChildScrollView(
            child: SizedBox(
              height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight - (Scaffold.of(context).appBarMaxHeight ?? AppSize.s50.rh),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.s16.rw,
                      vertical: AppSize.s16.rh,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          LabeledTextField(
                            label: AppStrings.first_name.tr(),
                            controller: _firstNameController,
                            textInputAction: TextInputAction.next,
                            validation: (String? text) {
                              if (text.isNullOrEmpty() == true) {
                                return AppStrings.field_required.tr();
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSize.s23.rh),
                          LabeledTextField(
                            label: AppStrings.last_name.tr(),
                            textInputAction: TextInputAction.next,
                            controller: _lastNameController,
                            validation: (String? text) {
                              if (text.isNullOrEmpty() == true) {
                                return AppStrings.field_required.tr();
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSize.s23.rh),
                          LabeledTextField(
                            label: AppStrings.contact_number.tr(),
                            textInputAction: TextInputAction.done,
                            controller: _phoneNameController,
                            inputType: TextInputType.phone,
                            validation: (String? text) {
                              if (text == null || text.length < 10 || text.length > 18) {
                                return AppStrings.phone_validation_message.tr();
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSize.s23.rh),
                          LabeledTextField(
                            label: AppStrings.email_address.tr(),
                            controller: _emailNameController,
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.s16.rw,
                      vertical: AppSize.s16.rh,
                    ),
                    child: BlocConsumer<UpdateUserInfoCubit, CubitState>(
                      listener: (context, state) {
                        _updateButtonController.setLoaded(state is! Loading);

                        if (state is Failed) {
                          showApiErrorSnackBar(context, state.failure);
                        } else if (state is Success<SuccessResponse>) {
                          showSuccessSnackBar(context, state.data.message);
                          _saveUpdatedUserInfo();
                        }
                      },
                      builder: (context, state) {
                        return KTButton(
                          controller: _updateButtonController,
                          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP300),
                          labelStyle: mediumTextStyle(color: AppColors.white),
                          progressPrimaryColor: AppColors.white,
                          verticalContentPadding: 10.rh,
                          onTap: () {
                            _validateAndUpdate(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNameController.dispose();
    _emailNameController.dispose();
    _updateButtonController.dispose();
    super.dispose();
  }
}
