import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/labeled_textfield.dart';
import 'package:klikit/modules/user/data/request_model/change_password_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/presentation/chnage_password/cubit/change_password_cubit.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../app/size_config.dart';
import '../../../../resources/strings.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _updateButtonController = KTButtonController(label: AppStrings.update.tr());
  final _key = GlobalKey<FormState>();

  void _validateANdChangePassword(BuildContext context) {
    if (_key.currentState!.validate()) {
      context.read<ChangePasswordCubit>().changePasswordAndLogout(
            ChangePasswordRequestModel(
              _currentPasswordController.text,
              _newPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<ChangePasswordCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.change_password.tr()),
        ),
        body: Builder(
          builder: (context) => SingleChildScrollView(
            child: SizedBox(
              height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight - (Scaffold.of(context).appBarMaxHeight ?? 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          LabeledTextField(
                            label: AppStrings.current_password.tr(),
                            controller: _currentPasswordController,
                            hintText: AppStrings.enter_your_current_password.tr(),
                            passwordField: true,
                            textInputAction: TextInputAction.next,
                            validation: (String? text) {
                              if (text.isNullOrEmpty() == true) {
                                return AppStrings.current_password_required.tr();
                              }
                              return null;
                            },
                          ).setVisibilityWithSpace(startSpace: AppSize.s10.rh, direction: Axis.vertical, endSpace: AppSize.s20.rh),
                          LabeledTextField(
                            label: AppStrings.new_password.tr(),
                            controller: _newPasswordController,
                            hintText: AppStrings.enter_your_new_password.tr(),
                            passwordField: true,
                            textInputAction: TextInputAction.next,
                            validation: (String? text) {
                              if (text.isNullOrEmpty() == true) {
                                return AppStrings.please_enter_new_password.tr();
                              }
                              return null;
                            },
                          ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s20.rh),
                          LabeledTextField(
                            label: AppStrings.confirm_new_password.tr(),
                            controller: _confirmPasswordController,
                            hintText: AppStrings.enter_your_new_password.tr(),
                            passwordField: true,
                            textInputAction: TextInputAction.done,
                            validation: (String? text) {
                              if (text.isNullOrEmpty() == true) {
                                return AppStrings.please_enter_password_again.tr();
                              } else if (_newPasswordController.value.text != _confirmPasswordController.value.text) {
                                return AppStrings.new_and_confirm_not_match.tr();
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(AppSize.s16.rw, AppSize.s16.rh, AppSize.s16.rw, AppSize.s20.rh),
                    child: BlocConsumer<ChangePasswordCubit, CubitState>(
                      listener: (context, state) {
                        _updateButtonController.setLoaded(state is! Loading);

                        if (state is Success<SuccessResponse>) {
                          showSuccessSnackBar(context, state.data.message);
                          SessionManager().logout();
                        } else if (state is Failed) {
                          showApiErrorSnackBar(context, state.failure);
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
                            _validateANdChangePassword(context);
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
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _updateButtonController.dispose();
    super.dispose();
  }
}
