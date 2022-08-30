import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/user/data/request_model/login_request_model.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/modules/user/presentation/bloc/login_bloc.dart';
import 'package:klikit/modules/user/presentation/bloc/login_event.dart';
import 'package:klikit/modules/user/presentation/bloc/login_state.dart';
import 'package:klikit/modules/user/presentation/widgets/input_feild.dart';
import 'package:klikit/modules/user/presentation/widgets/login_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  void _login(BuildContext context) {
    context.read<LoginBloc>().add(
          LoginEventAuthenticate(
            LoginRequestModel(_emailController.text, _passwordController.text),
          ),
        );
  }

  void _checkRole(User user, BuildContext context) {
    final role = user.userInfo.roles.firstWhere(
      (role) => role == AppConstant.roleManger,
      orElse: () => EMPTY,
    );
    if(role == AppConstant.roleManger){
      _saveUserDataAndNavigateToBase(user, context);
    }else{
      showErrorSnackBar(context, AppStrings.login_as_manager);
    }
  }

  void _saveUserDataAndNavigateToBase(User user, BuildContext context){
    final appPreference = getIt.get<AppPreferences>();
    appPreference.insertAccessToken(user.accessToken);
    appPreference.insertRefreshToken(user.refreshToken);
    appPreference.loggedInUser(user).then((_){
      Navigator.of(context).pushReplacementNamed(Routes.base);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt.get<LoginBloc>(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.black,
          body: SingleChildScrollView(
            child: SizedBox(
              height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight,
              width: ScreenSizes.screenWidth,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s43.rw,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppImages.klikit),
                        SizedBox(
                          width: AppSize.s8.rw,
                        ),
                        Text(
                          AppStrings.cloud.tr(),
                          style: getBoldTextStyle(
                            color: AppColors.yellow,
                            fontSize: AppSize.s48.rSp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSize.s20.rh,
                    ),
                    Text(
                      AppStrings.existing_account.tr(),
                      style: getRegularTextStyle(
                        color: AppColors.white,
                        fontSize: AppSize.s16.rSp,
                      ),
                    ),
                    Text(
                      AppStrings.dont_have_account.tr(),
                      style: getBoldTextStyle(
                        color: AppColors.primary,
                        fontSize: AppSize.s16.rSp,
                      ),
                    ),
                    SizedBox(
                      height: AppSize.s34.rh,
                    ),
                    InputField(
                      label: AppStrings.email.tr(),
                      controller: _emailController,
                      inputType: TextInputType.emailAddress,
                      obscureText: false,
                    ),
                    SizedBox(
                      height: AppSize.s34.rh,
                    ),
                    InputField(
                      label: AppStrings.password.tr(),
                      controller: _passwordController,
                      inputType: TextInputType.text,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: AppSize.s28.rh,
                    ),
                    Text(
                      AppStrings.forgot_password.tr(),
                      style: TextStyle(
                          fontFamily: AppFonts.fontFamilyAeonik,
                          color: AppColors.primarySecond,
                          fontSize: AppSize.s16.rSp,
                          fontWeight: AppFontWeight.regular,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: AppSize.s28.rh,
                    ),
                    BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                      if (state is LoginStateError) {
                        showErrorSnackBar(context, state.failure.message);
                      } else if (state is LoginStateSuccess) {
                        _checkRole(state.user, context);
                      }
                    }, builder: (context, state) {
                      return LoginButton(
                        isLoading: (state is LoginStateLoading),
                        onTap: () {
                          _login(context);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
