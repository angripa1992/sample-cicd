import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/modules/user/data/request_model/change_password_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/presentation/chnage_password/components/password_feild.dart';
import 'package:klikit/modules/user/presentation/chnage_password/cubit/change_password_cubit.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/modules/widgets/url_text_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/values.dart';

import '../../../../app/size_config.dart';
import '../../../../resources/strings.dart';
import '../../../../resources/styles.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final _preferences = getIt.get<AppPreferences>();

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
          title: Text(AppStrings.account.tr()),
          titleTextStyle: getAppBarTextStyle(),
          flexibleSpace: getAppBarBackground(),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight,
            width: ScreenSizes.screenWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s20.rw, vertical: AppSize.s12.rh),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.change_password.tr(),
                    style: getRegularTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s20.rSp,
                    ),
                  ),
                  SizedBox(height: AppSize.s24.rh),
                  Form(
                    key: _key,
                    child: Column(
                      children: [
                        PasswordField(
                          label: AppStrings.current_password.tr(),
                          hint: AppStrings.enter_your_current_password.tr(),
                          editingController: _currentPasswordController,
                          newPasswordController: _newPasswordController,
                          type: PasswordFieldType.CURRENT,
                        ),
                        SizedBox(height: AppSize.s24.rh),
                        PasswordField(
                          label: AppStrings.new_password.tr(),
                          hint: AppStrings.enter_your_new_password.tr(),
                          editingController: _newPasswordController,
                          newPasswordController: _newPasswordController,
                          type: PasswordFieldType.NEW,
                        ),
                        SizedBox(height: AppSize.s24.rh),
                        PasswordField(
                          label: AppStrings.confirm_new_password.tr(),
                          hint: AppStrings.enter_your_new_password.tr(),
                          editingController: _confirmPasswordController,
                          newPasswordController: _newPasswordController,
                          type: PasswordFieldType.CONFIRM,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.s24.rh),
                  BlocConsumer<ChangePasswordCubit, CubitState>(
                    builder: (context, state) {
                      return LoadingButton(
                        isLoading: (state is Loading),
                        text: AppStrings.update.tr(),
                        onTap: () {
                          _validateANdChangePassword(context);
                        },
                      );
                    },
                    listener: (context, state) {
                      if (state is Success<SuccessResponse>) {
                        showSuccessSnackBar(context, state.data.message);
                        SessionManager().logout();
                      } else if (state is Failed) {
                        showApiErrorSnackBar(context, state.failure);
                      }
                    },
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
    super.dispose();
  }
}
