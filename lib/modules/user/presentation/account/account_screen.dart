import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/modules/base/chnage_language_cubit.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/presentation/account/cubit/logout_cubit.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';
import 'package:klikit/segments/event_manager.dart';

import '../../../../app/session_manager.dart';
import '../../../../consumer_protection/presentation/consumer_protection_view.dart';
import '../../../../consumer_protection/presentation/cubit/consumer_protection_cubit.dart';
import '../../../../core/route/routes.dart';
import '../../../../language/language_manager.dart';
import '../../../../language/language_setting_page.dart';
import '../../../../resources/fonts.dart';
import '../../../../segments/segemnt_data_provider.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/snackbars.dart';
import 'component/account_header.dart';
import 'component/account_setting_item.dart';
import 'component/app_version_info.dart';
import 'component/notification_settings/notification_settings_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _languageManager = getIt.get<LanguageManager>();

  @override
  void initState() {
    SegmentManager().screen(
      event: SegmentEvents.ACCOUNT_TAB,
      name: 'Account Tab',
    );
    super.initState();
  }

  void _onLanguageChange() {
    showLanguageSettingDialog(
      context: context,
      onLanguageChange: (locale, id) {
        _languageManager.changeLocale(
          context: context,
          locale: locale,
          languageId: id,
        );
        context.read<ChangeLanguageCubit>().openLanguageSettingDialog(locale, id);
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          icon: Icon(
            Icons.logout,
            color: AppColors.redDark,
          ),
          title: Text(AppStrings.logout.tr()),
          actionsAlignment: MainAxisAlignment.end,
          actionsPadding: EdgeInsets.only(
            right: AppSize.s16.rw,
            left: AppSize.s16.rw,
            bottom: AppSize.s16.rh,
          ),
          actions: [
            AppButton(
              text: AppStrings.cancel.tr(),
              color: AppColors.white,
              textColor: AppColors.black,
              borderColor: AppColors.black,
              onTap: () {
                Navigator.of(dContext).pop();
              },
            ),
            SizedBox(height: AppSize.s8.rh),
            AppButton(
              text: AppStrings.logout.tr(),
              color: AppColors.white,
              textColor: AppColors.redDark,
              borderColor: AppColors.redDark,
              onTap: () {
                Navigator.of(dContext).pop();
                context.read<LogoutCubit>().logout();
              },
            ),
          ],
          content: Text(
            AppStrings.logout_confirm_message.tr(),
            textAlign: TextAlign.center,
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (_) => getIt.get<LogoutCubit>()),
        BlocProvider(lazy: false, create: (_) => getIt.get<ConsumerProtectionCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.account.tr()),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.s18.rh,
              horizontal: AppSize.s16.rw,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AccountHeader(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSize.s16.rh),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppButton(
                          text: AppStrings.edit_profile.tr(),
                          icon: Icons.edit_outlined,
                          color: AppColors.white,
                          textColor: AppColors.black,
                          borderColor: AppColors.black,
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.editProfile);
                          },
                        ),
                      ),
                      SizedBox(width: AppSize.s16.rw),
                      Expanded(
                        child: BlocConsumer<LogoutCubit, CubitState>(
                          listener: (context, state) {
                            if (state is Failed) {
                              showApiErrorSnackBar(context, state.failure);
                            } else if (state is Success<SuccessResponse>) {
                              showSuccessSnackBar(context, state.data.message);
                              SegmentManager().identify(event: SegmentEvents.USER_LOGGED_OUT);
                              SessionManager().logout();
                            }
                          },
                          builder: (context, state) {
                            return LoadingButton(
                              isLoading: (state is Loading),
                              text: AppStrings.logout.tr(),
                              color: AppColors.white,
                              borderColor: AppColors.redDark,
                              textColor: AppColors.redDark,
                              icon: Icons.logout_outlined,
                              onTap: () {
                                _showLogoutDialog(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  AppStrings.settings.tr(),
                  style: boldTextStyle(
                    color: AppColors.black,
                    fontSize: AppSize.s16.rSp,
                  ),
                ),
                const Divider(),
                const NotificationSettingScreen(),
                AccountSettingItem(
                  title: AppStrings.change_language.tr(),
                  iconData: Icons.language_outlined,
                  onTap: _onLanguageChange,
                ),
                AccountSettingItem(
                  title: AppStrings.printer_settings.tr(),
                  iconData: Icons.print,
                  onTap: () {
                    SegmentManager().track(
                      event: SegmentEvents.MODULE_CLICK_PRINTER_SETTINGS,
                      properties: {
                        'brand_ids': SessionManager().brandIDs().toString(),
                        'branch_ids': SessionManager().branchIDs().toString(),
                        'business_id': SessionManager().businessID(),
                      },
                    );

                    Navigator.of(context).pushNamed(Routes.printerSettings);
                  },
                ),
                AccountSettingItem(
                  title: AppStrings.device_setting.tr(),
                  iconData: Icons.phone_android_rounded,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.deviceSetting);
                  },
                ),
                AccountSettingItem(
                  title: AppStrings.contact_support.tr(),
                  iconData: Icons.help_outline,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.contactSupport);
                  },
                ),
                AccountSettingItem(
                  title: AppStrings.change_password.tr(),
                  iconData: Icons.key_outlined,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.changePassword);
                  },
                ),
                const Divider(),
                AppVersionInfo(),
                const ConsumerProtectionView(
                  loggedIn: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
