import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/user/data/request_model/login_request_model.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/modules/user/presentation/login/bloc/login_bloc.dart';
import 'package:klikit/modules/user/presentation/login/components/login_form.dart';
import 'package:klikit/modules/user/presentation/login/components/logo.dart';
import 'package:klikit/modules/widgets/dialogs.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/modules/widgets/url_text_button.dart';
import 'package:klikit/notification/fcm_service.dart';
import 'package:klikit/notification/fcm_token_manager.dart';
import 'package:klikit/notification/notification_handler.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';
import 'package:klikit/segments/event_manager.dart';

import '../../../../app/session_manager.dart';
import '../../../../consumer_protection/presentation/consumer_protection_view.dart';
import '../../../../consumer_protection/presentation/cubit/consumer_protection_cubit.dart';
import '../../../../segments/segemnt_data_provider.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fcmTokenManager = getIt.get<FcmTokenManager>();
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic>? args;

  @override
  void initState() {
    _emailController.text = SessionManager().lastLoginEmail();
    super.initState();
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
            LoginEventAuthenticate(
              LoginRequestModel(
                _emailController.text,
                _passwordController.text,
              ),
            ),
          );
    }
  }

  void _checkRole(User user) {
    var role = user.userInfo.roles.firstWhere(
      (role) => role == AppConstant.roleBranchManger,
      orElse: () => EMPTY,
    );
    if (role == EMPTY && user.userInfo.roles.isNotEmpty) {
      role = user.userInfo.roles[0];
    }
    switch (role) {
      case AppConstant.roleBranchManger:
        _saveUserData(user);
        break;
      case AppConstant.roleAdmin:
        showAccessDeniedDialog(context: context, role: AppStrings.admin.tr());
        break;
      case AppConstant.roleBrandManager:
        showAccessDeniedDialog(
            context: context, role: AppStrings.brand_manager.tr());
        break;
      default:
        showAccessDeniedDialog(
          context: context,
          role: AppStrings.business_owner.tr(),
        );
        break;
    }
  }

  void _saveUserData(User user) async {
    await SessionManager().saveLastLoginEmail(user.userInfo.email);
    await SessionManager().saveToken(
      accessToken: user.accessToken,
      refreshToken: user.refreshToken,
    );
    await SessionManager().setLoginState(isLoggedIn: true);
    await SessionManager().setNotificationEnabled(user.userInfo.orderNotificationEnabled);
    SessionManager().saveUser(user.userInfo).then((_) {
      _registerFcmToken(user);
      SegmentManager().identify(event: SegmentEvents.USER_LOGGED_IN);
    });
  }

  Future _registerFcmToken(User user) async {
    final fcmToken = await FcmService().getFcmToken();
    final response = await _fcmTokenManager.registerToken(fcmToken ?? '');
    response.fold(
      (failure) {
        showApiErrorSnackBar(context, failure);
      },
      (success) {
        _navigate(user);
      },
    );
  }

  void _navigate(User user) {
    if (user.userInfo.firstLogin) {
      Navigator.of(context).pushReplacementNamed(Routes.changePassword);
    } else if (args == null) {
      Navigator.of(context).pushReplacementNamed(Routes.base);
    } else {
      NotificationHandler().navigateToOrderScreen(
        args![ArgumentKey.kNOTIFICATION_DATA],
        notificationType: NotificationType.BACKGROUD,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => getIt.get<LoginBloc>()),
        BlocProvider(
            create: (BuildContext context) =>
                getIt.get<ConsumerProtectionCubit>()),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.black,
          body: SingleChildScrollView(
            child: Container(
              height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight,
              width: ScreenSizes.screenWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.loginBgModified),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s50.rw,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LogoView(),
                    SizedBox(
                      height: AppSize.s8.rh,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.existing_account.tr(),
                          style: getRegularTextStyle(
                            color: AppColors.manilla,
                            fontSize: AppSize.s14.rSp,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              Routes.webView,
                              arguments: AppConstant.signUpUrl,
                            );
                          },
                          child: Text(
                            AppStrings.dont_have_account.tr(),
                            style: getBoldTextStyle(
                              color: AppColors.manilla,
                              fontSize: AppFontSize.s14.rSp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppSize.s24.rh,
                        ),
                        LoginForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                        SizedBox(
                          height: AppSize.s8.rh,
                        ),
                        UrlTextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(Routes.forget);
                          },
                          text: AppStrings.forgot_password.tr(),
                          color: AppColors.manilla,
                          textSize: AppSize.s14.rSp,
                        ),
                        SizedBox(
                          height: AppSize.s24.rh,
                        ),
                        BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginStateError) {
                              showApiErrorSnackBar(context, state.failure);
                            } else if (state is LoginStateSuccess) {
                              _checkRole(state.user);
                            }
                          },
                          builder: (context, state) {
                            return LoadingButton(
                              text: AppStrings.login.tr(),
                              verticalPadding: AppSize.s12.rh,
                              isLoading: (state is LoginStateLoading),
                              onTap: () {
                                _login(context);
                              },
                            );
                          },
                        ),
                        const ConsumerProtectionView(
                          loggedIn: false,
                        ),
                      ],
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
