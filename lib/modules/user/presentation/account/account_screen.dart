import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/modules/base/chnage_language_cubit.dart';
import 'package:klikit/modules/user/data/request_model/user_update_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/modules/user/domain/usecases/update_user_info.dart';
import 'package:klikit/modules/user/presentation/account/component/edit_profile_textfield.dart';
import 'package:klikit/modules/user/presentation/account/cubit/logout_cubit.dart';
import 'package:klikit/modules/user/presentation/account/cubit/update_user_info_cubit.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';
import 'package:klikit/segments/event_manager.dart';

import '../../../../app/session_manager.dart';
import '../../../../consumer_protection/presentation/consumer_protection_view.dart';
import '../../../../consumer_protection/presentation/cubit/consumer_protection_cubit.dart';
import '../../../../language/language_manager.dart';
import '../../../../language/language_setting_page.dart';
import '../../../../segments/segemnt_data_provider.dart';
import '../../../widgets/dialogs.dart';
import '../../../widgets/snackbars.dart';
import 'component/account_action_header.dart';
import 'component/app_version_info.dart';
import 'component/notification_settings/notification_settings_screen.dart';

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
  final _languageManager = getIt.get<LanguageManager>();
  late UserInfo _user;

  @override
  void initState() {
    _user = SessionManager().currentUser();
    _firstNameController.text = _user.firstName;
    _lastNameController.text = _user.lastName;
    _phoneNameController.text = _user.phone;
    _emailNameController.text = _user.email;
    SegmentManager()
        .screen(event: SegmentEvents.ACCOUNT_TAB, name: 'Account Tab');
    super.initState();
  }

  void _validateAndUpdate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
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
                  branchId: _user.branchId,
                  brandId: _user.brandId == 0 ? null : _user.brandId,
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
      _user = SessionManager().currentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (_) => getIt.get<LogoutCubit>()),
        BlocProvider(
            lazy: false, create: (_) => getIt.get<UpdateUserInfoCubit>()),
        BlocProvider(
            lazy: false, create: (_) => getIt.get<ConsumerProtectionCubit>()),
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
                  AccountActionHeader(
                    onLanguageChange: () {
                      showLanguageSettingDialog(
                        context: context,
                        onLanguageChange: (locale, id) {
                          _languageManager.changeLocale(
                            context: context,
                            locale: locale,
                            languageId: id,
                          );
                          context
                              .read<ChangeLanguageCubit>()
                              .openLanguageSettingDialog(locale, id);
                        },
                      );
                    },
                  ),
                  SizedBox(height: AppSize.s16.rh),
                  const NotificationSettingScreen(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSize.s10.rh),
                    child: Text(
                      AppStrings.edit_profile.tr(),
                      style: boldTextStyle(
                        color: AppColors.bluewood,
                        fontSize: AppSize.s16.rSp,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        EditProfileTextField(
                          currentValue: _user.firstName,
                          label: AppStrings.first_name.tr(),
                          editingController: _firstNameController,
                          enabled: true,
                        ),
                        SizedBox(height: AppSize.s23.rh),
                        EditProfileTextField(
                          currentValue: _user.lastName,
                          label: AppStrings.last_name.tr(),
                          editingController: _lastNameController,
                          enabled: true,
                        ),
                        SizedBox(height: AppSize.s23.rh),
                        EditProfileTextField(
                          currentValue: _user.phone,
                          label: AppStrings.contact_number.tr(),
                          editingController: _phoneNameController,
                          enabled: true,
                          inputType: TextInputType.phone,
                        ),
                        SizedBox(height: AppSize.s23.rh),
                        EditProfileTextField(
                          currentValue: _user.email,
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
                        child: BlocConsumer<LogoutCubit, CubitState>(
                          listener: (context, state) {
                            if (state is Failed) {
                              showApiErrorSnackBar(context, state.failure);
                            } else if (state is Success<SuccessResponse>) {
                              showSuccessSnackBar(context, state.data.message);
                              SegmentManager().identify(
                                  event: SegmentEvents.USER_LOGGED_OUT);
                              SessionManager().logout();
                            }
                          },
                          builder: (context, state) {
                            return LoadingButton(
                              isLoading: (state is Loading),
                              text: AppStrings.logout.tr(),
                              verticalPadding: AppSize.s8.rh,
                              bgColor: Colors.transparent,
                              borderColor: AppColors.warmRed,
                              textColor: AppColors.warmRed,
                              loadingBgColor: Colors.transparent,
                              loaderColor: AppColors.warmRed,
                              loadingBorderColor: AppColors.warmRed,
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
                      SizedBox(
                        width: AppSize.s16.rw,
                      ),
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
                    ],
                  ),
                  const ConsumerProtectionView(
                    loggedIn: true,
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
