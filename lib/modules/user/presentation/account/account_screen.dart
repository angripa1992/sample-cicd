import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/order_information_provider.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/modules/user/data/request_model/user_update_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/modules/user/domain/usecases/update_user_info.dart';
import 'package:klikit/modules/user/presentation/account/component/edit_profile_textfield.dart';
import 'package:klikit/modules/user/presentation/account/cubit/logout_cubit.dart';
import 'package:klikit/modules/user/presentation/account/cubit/update_user_info_cubit.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/url_text_button.dart';
import 'package:klikit/notification/inapp/in_app_notification_handler.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../widgets/dialogs.dart';
import '../../../widgets/snackbars.dart';
import 'component/app_version_info.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNameController = TextEditingController();
  final _emailNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _appPreferences = getIt.get<AppPreferences>();
  final _orderInfoProvider = getIt.get<OrderInformationProvider>();
  late User _user;

  @override
  void initState() {
    _user = _appPreferences.getUser();
    _firstNameController.text = _user.userInfo.firstName;
    _lastNameController.text = _user.userInfo.lastName;
    _phoneNameController.text = _user.userInfo.phone;
    _emailNameController.text = _user.userInfo.email;
    super.initState();
  }

  void _validateAndUpdate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      bool isSameFirstName =
          _firstNameController.text == _user.userInfo.firstName;
      bool isSameLastName = _lastNameController.text == _user.userInfo.lastName;
      bool isSamePhone = _phoneNameController.text == _user.userInfo.phone;
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
                  branchId: _user.userInfo.branchId,
                  brandId: _user.userInfo.brandId == 0
                      ? null
                      : _user.userInfo.brandId,
                  businessId: _user.userInfo.businessId,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  phone: _phoneNameController.text,
                  roleIds: _user.userInfo.roleIds,
                  countryIds: _user.userInfo.countryIds,
                ),
                _user.userInfo.id,
              ),
            );
      }
    }
  }

  void _saveUpdatedUserInfo() async {
    await _appPreferences.saveUser(
      _user.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneNameController.text,
      ),
    );
    setState(() {
      _user = _appPreferences.getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (_) => getIt.get<LogoutCubit>()),
        BlocProvider(
            lazy: false, create: (_) => getIt.get<UpdateUserInfoCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: Text(AppStrings.account.tr()),
          titleTextStyle: getAppBarTextStyle(),
          centerTitle: true,
          flexibleSpace: getAppBarBackground(),
        ),
        body: SizedBox(
          height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight,
          width: ScreenSizes.screenWidth,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.s18.rh,
                horizontal: AppSize.s20.rw,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.edit_profile.tr(),
                    style: getMediumTextStyle(
                      color: AppColors.purpleBlue,
                      fontSize: AppSize.s20.rSp,
                    ),
                  ),
                  SizedBox(height: AppSize.s12.rh),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        EditProfileTextField(
                          currentValue: _user.userInfo.firstName,
                          label: AppStrings.first_name.tr(),
                          editingController: _firstNameController,
                          enabled: true,
                        ),
                        SizedBox(height: AppSize.s23.rh),
                        EditProfileTextField(
                          currentValue: _user.userInfo.lastName,
                          label: AppStrings.last_name.tr(),
                          editingController: _lastNameController,
                          enabled: true,
                        ),
                        SizedBox(height: AppSize.s23.rh),
                        EditProfileTextField(
                          currentValue: _user.userInfo.phone,
                          label: AppStrings.contact_number.tr(),
                          editingController: _phoneNameController,
                          enabled: true,
                          inputType: TextInputType.phone,
                        ),
                        SizedBox(height: AppSize.s23.rh),
                        EditProfileTextField(
                          currentValue: _user.userInfo.email,
                          label: AppStrings.email_address.tr(),
                          editingController: _emailNameController,
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppSize.s20.rh,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: BlocConsumer<UpdateUserInfoCubit, CubitState>(
                          listener: (context, state) {
                            if (state is Failed) {
                              showApiErrorSnackBar(context, state.failure);
                            } else if (state is Success<SuccessResponse>) {
                              showSuccessSnackBar(context, state.data.message);
                              _saveUpdatedUserInfo();
                            }
                          },
                          builder: (context, state) {
                            return LoadingButton(
                              isLoading: (state is Loading),
                              text: AppStrings.update.tr(),
                              verticalPadding: AppSize.s8.rh,
                              onTap: () {
                                _validateAndUpdate(context);
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: AppSize.s16.rw,
                      ),
                      Expanded(
                        child: BlocConsumer<LogoutCubit, CubitState>(
                          listener: (context, state) {
                            if (state is Failed) {
                              showApiErrorSnackBar(context, state.failure);
                            } else if (state is Success<SuccessResponse>) {
                              showSuccessSnackBar(context, state.data.message);
                              _orderInfoProvider.clearData();
                              InAppNotificationHandler()
                                  .dismissInAppNotification();
                              getIt
                                  .get<AppPreferences>()
                                  .clearPreferences()
                                  .then(
                                (value) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Routes.login, (route) => false);
                                },
                              );
                            }
                          },
                          builder: (context, state) {
                            return LoadingButton(
                              isLoading: (state is Loading),
                              text: AppStrings.logout.tr(),
                              verticalPadding: AppSize.s8.rh,
                              onTap: () {
                                showLogoutDialog(
                                  context: context,
                                  onLogout: () {
                                    context.read<LogoutCubit>().logout();
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSize.s12.rh,
                  ),
                  Row(
                    children: [
                      Icon(Icons.edit, color: AppColors.purpleBlue),
                      SizedBox(
                        width: AppSize.s8.rw,
                      ),
                      Expanded(
                        child: UrlTextButton(
                          fontWeight: AppFontWeight.regular,
                          textSize: AppFontSize.s14.rSp,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(Routes.changePassword);
                          },
                          color: AppColors.purpleBlue,
                          text: AppStrings.change_your_password.tr(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.print, color: AppColors.purpleBlue),
                      SizedBox(
                        width: AppSize.s8.rw,
                      ),
                      Expanded(
                        child: UrlTextButton(
                          fontWeight: AppFontWeight.regular,
                          textSize: AppFontSize.s14.rSp,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(Routes.printerSettings);
                          },
                          color: AppColors.purpleBlue,
                          text: AppStrings.printer_settings.tr(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.support_agent_sharp,
                          color: AppColors.purpleBlue),
                      SizedBox(
                        width: AppSize.s8.rw,
                      ),
                      Expanded(
                        child: UrlTextButton(
                          fontWeight: AppFontWeight.regular,
                          textSize: AppFontSize.s14.rSp,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(Routes.contactSupport);
                          },
                          color: AppColors.purpleBlue,
                          text: AppStrings.contact_support.tr(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: AppSize.s16.rh),
                    child: AppVersionInfo(),
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
    super.dispose();
  }
}
