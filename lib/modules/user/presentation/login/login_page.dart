import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/core/utils/socket_handler.dart';
import 'package:klikit/modules/user/data/request_model/login_request_model.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/modules/user/presentation/login/bloc/login_bloc.dart';
import 'package:klikit/modules/user/presentation/login/components/login_form.dart';
import 'package:klikit/modules/widgets/dialogs.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/modules/widgets/url_text_button.dart';
import 'package:klikit/notification/fcm_service.dart';
import 'package:klikit/notification/fcm_token_manager.dart';
import 'package:klikit/notification/notification_handler.dart';
import 'package:klikit/printer/printer_local_data_manager.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';
import 'package:klikit/segments/event_manager.dart';

import '../../../../app/session_manager.dart';
import '../../../../app/user_permission_manager.dart';
import '../../../../consumer_protection/presentation/consumer_protection_view.dart';
import '../../../../consumer_protection/presentation/cubit/consumer_protection_cubit.dart';
import '../../../../segments/segemnt_data_provider.dart';
import '../header_view.dart';
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
    final role = user.userInfo.roles.first;
    final displayRole = user.userInfo.displayRoles.first;
    if (role == UserRole.businessOwner || role == UserRole.branchManger || role == UserRole.staff || role == UserRole.cashier) {
      _saveUserDataAndRegisterFcmToken(user);
    } else {
      showAccessDeniedDialog(context: context, role: displayRole);
    }
  }

  void _saveUserDataAndRegisterFcmToken(User user) async {
    await SessionManager().saveLastLoginEmail(user.userInfo.email);
    await SessionManager().saveToken(accessToken: user.accessToken, refreshToken: user.refreshToken);
    await SessionManager().setLoginState(isLoggedIn: true);
    await _saveUserSetting(user.userInfo);
    await SessionManager().saveUser(user.userInfo);
    if (UserPermissionManager().isBizOwner()) {
      _navigateNextScreen(user);
    } else {
      _registerFcmTokenAndNavigateNextScreen(user);
    }
  }

  Future<void> _saveUserSetting(UserInfo userInfo) async {
    await SessionManager().setNotificationEnabled(userInfo.orderNotificationEnabled);
    await LocalPrinterDataManager().setActiveDevice(userInfo.printingDeviceId);
  }

  Future _registerFcmTokenAndNavigateNextScreen(User user) async {
    // final fcmToken = await FcmService().getFcmToken();
    // final response = await _fcmTokenManager.registerToken(fcmToken);
    // response.fold(
    //   (failure) {
    //     showApiErrorSnackBar(context, failure);
    //   },
    //   (success) {
        _navigateNextScreen(user);
    //   },
    // );
  }

  void _navigateNextScreen(User user) {
    if (user.userInfo.firstLogin) {
      Navigator.of(context).pushReplacementNamed(Routes.changePassword);
    } else if (args == null) {
      Navigator.of(context).pushReplacementNamed(Routes.base, arguments: null);
      SegmentManager().identify(event: SegmentEvents.USER_LOGGED_IN);
    } else {
      NotificationHandler().navigateToOrderScreen(
        args![ArgumentKey.kNOTIFICATION_DATA],
        notificationType: NotificationType.BACKGROUD,
      );
    }
  }
  _initSocket(){
    final socketHandler = getIt.get<SocketHandler>();
    socketHandler.onStart();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => getIt.get<LoginBloc>()),
        BlocProvider(create: (BuildContext context) => getIt.get<ConsumerProtectionCubit>()),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const RegistrationHeaderView(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s16.rw,
                    vertical: AppSize.s32.rh,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSize.s12.rh,
                        ),
                        child: LoginForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: UrlTextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(Routes.forget);
                          },
                          text: AppStrings.forgot_password.tr(),
                          color: AppColors.primaryDark,
                          textSize: AppSize.s14.rSp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSize.s12.rh,
                        ),
                        child: BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginStateError) {
                              showApiErrorSnackBar(context, state.failure);
                            } else if (state is LoginStateSuccess) {
                              _checkRole(state.user);
                              Future.delayed(const Duration(seconds: 2), () async {
                                _initSocket();
                              });

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
                      ),
                      Row(
                        children: [
                          Text(
                            '${AppStrings.existing_account.tr()}. ',
                            style: regularTextStyle(
                              color: AppColors.black,
                              fontSize: AppSize.s14.rSp,
                            ),
                          ),
                          // TextButton(
                          //   style: TextButton.styleFrom(
                          //     padding: EdgeInsets.zero,
                          //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //     alignment: Alignment.centerLeft,
                          //   ),
                          //   onPressed: () {
                          //     Navigator.of(context).pushNamed(Routes.webView, arguments: AppConstant.signUpUrl);
                          //   },
                          //   child: Text(
                          //     AppStrings.dont_have_account.tr(),
                          //     style: boldTextStyle(
                          //       color: AppColors.primaryDark,
                          //       fontSize: AppFontSize.s14.rSp,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const ConsumerProtectionView(loggedIn: false),
                    ],
                  ),
                ),
              ],
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
