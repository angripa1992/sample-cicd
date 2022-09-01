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
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AppPreferences _appPreferences = getIt.get<AppPreferences>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text = _appPreferences.getLoginEmail();
    super.initState();
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
            LoginEventAuthenticate(
              LoginRequestModel(
                  _emailController.text, _passwordController.text),
            ),
          );
    }
  }

  void _checkRole(User user, BuildContext context) {
    final role = user.userInfo.roles.firstWhere(
      (role) => role == AppConstant.roleManger,
      orElse: () => EMPTY,
    );
    if (role == AppConstant.roleManger) {
      _saveUserDataAndNavigateToBase(user, context);
    } else {
      showErrorSnackBar(context, AppStrings.login_as_manager);
    }
  }

  void _saveUserDataAndNavigateToBase(User user, BuildContext context) {
    _appPreferences.saveLoginEmail(user.userInfo.email);
    _appPreferences.insertAccessToken(user.accessToken);
    _appPreferences.insertRefreshToken(user.refreshToken);
    _appPreferences.loggedInUser(user).then((_) {
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
                  horizontal: AppSize.s24.rw,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          child: Image.asset(
                            AppImages.klikit,
                            width: 87.rw,
                            height: 33.rh,
                          ),
                        ),
                        SizedBox(
                          width: AppSize.s8.rw,
                        ),
                        Text(
                          AppStrings.cloud.tr(),
                          style: getRegularTextStyle(
                            fontFamily: AppFonts.Abel,
                            color: AppColors.canaryYellow,
                            fontSize: AppSize.s40.rSp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSize.s8.rh,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSize.s20.rh,
                          horizontal: AppSize.s20.rw,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.existing_account.tr(),
                              style: getRegularTextStyle(
                                fontFamily: AppFonts.ABeeZee,
                                color: AppColors.blueViolet,
                                fontSize: AppSize.s16.rSp,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  Routes.webView,
                                  arguments: AppConstant.signUpUrl,
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                              child: Text(
                                AppStrings.dont_have_account.tr(),
                                style: getRegularTextStyle(
                                  fontFamily: AppFonts.ABeeZee,
                                  color: AppColors.purpleBlue,
                                  fontSize: AppSize.s16.rSp,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: AppSize.s24.rh,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  InputField(
                                    label: AppStrings.email.tr(),
                                    controller: _emailController,
                                    inputType: TextInputType.emailAddress,
                                    obscureText: false,
                                  ),
                                  SizedBox(
                                    height: AppSize.s28.rh,
                                  ),
                                  InputField(
                                    label: AppStrings.password.tr(),
                                    controller: _passwordController,
                                    inputType: TextInputType.text,
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: AppSize.s24.rh,
                            ),
                            TextButton(
                              onPressed: () {  },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                              child: Text(
                                AppStrings.forgot_password.tr(),
                                style: TextStyle(
                                  fontFamily: AppFonts.ABeeZee,
                                  color: AppColors.blueViolet,
                                  fontSize: AppSize.s16.rSp,
                                  fontWeight: AppFontWeight.regular,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: AppSize.s24.rh,
                            ),
                            BlocConsumer<LoginBloc, LoginState>(
                              listener: (context, state) {
                                if (state is LoginStateError) {
                                  showErrorSnackBar(
                                      context, state.failure.message);
                                } else if (state is LoginStateSuccess) {
                                  _checkRole(state.user, context);
                                }
                              },
                              builder: (context, state) {
                                return LoadingButton(
                                  text: AppStrings.login.tr(),
                                  isLoading: (state is LoginStateLoading),
                                  onTap: () {
                                    _login(context);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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
