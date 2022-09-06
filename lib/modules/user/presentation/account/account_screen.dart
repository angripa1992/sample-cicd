import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
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
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../widgets/dialogs.dart';
import '../../../widgets/snackbars.dart';

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

  void _saveUpdatedUserInfo() async{
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
        BlocProvider(lazy:false,create: (_) => getIt.get<LogoutCubit>()),
        BlocProvider(lazy:false,create: (_) => getIt.get<UpdateUserInfoCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: Text(AppStrings.account.tr()),
          titleTextStyle: getAppBarTextStyle(),
          centerTitle: true,
          flexibleSpace: getAppBarBackground(),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight,
            width: ScreenSizes.screenWidth,
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
                          label: AppStrings.phone.tr(),
                          editingController: _phoneNameController,
                          enabled: true,
                          inputType: TextInputType.phone,
                        ),
                        SizedBox(height: AppSize.s23.rh),
                        EditProfileTextField(
                          currentValue: _user.userInfo.email,
                          label: AppStrings.email.tr(),
                          editingController: _emailNameController,
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppSize.s32.rh,
                  ),
                  BlocConsumer<UpdateUserInfoCubit, CubitState>(
                    listener: (context, state) {
                      if (state is Failed) {
                        showErrorSnackBar(context, state.failure.message);
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
                  SizedBox(
                    height: AppSize.s20.rh,
                  ),
                  BlocConsumer<LogoutCubit, CubitState>(
                    listener: (context, state) {
                      if (state is Failed) {
                        showErrorSnackBar(context, state.failure.message);
                      } else if (state is Success<SuccessResponse>) {
                        showSuccessSnackBar(context, state.data.message);
                        getIt.get<AppPreferences>().clearPreferences().then(
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
                  SizedBox(
                    height: AppSize.s20.rh,
                  ),
                  UrlTextButton(
                    onPressed: () {},
                    color: AppColors.black,
                    text: AppStrings.change_your_password.tr(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
