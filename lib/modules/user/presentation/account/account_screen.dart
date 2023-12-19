import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/core/widgets/actionable_tile.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/modal_sheet_manager.dart';
import 'package:klikit/modules/base/chnage_language_cubit.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/presentation/account/component/device_setting_view.dart';
import 'package:klikit/modules/user/presentation/account/cubit/logout_cubit.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';
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
import 'component/app_version_info.dart';
import 'component/notification_settings/notification_settings_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _languageManager = getIt.get<LanguageManager>();
  final _businessInfoProvider = getIt.get<BusinessInformationProvider>();
  late final logoutButtonController = KTButtonController(AppStrings.logout.tr(), true);

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

  void _onDeviceChange() {
    ModalSheetManager.openBottomSheet(
      context,
      const DeviceSettingScreen(),
      title: AppStrings.device_setting.tr(),
      showCloseButton: true,
      dismissible: false,
    ).then(
      (value) {
        if (value is Failure) {
          showApiErrorSnackBar(context, value);
        } else if (value is String) {
          showSuccessSnackBar(context, value);
        }
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

  void trackPrinterSettingsClickEvent() async {
    final brandIds = await _businessInfoProvider.findBrandsIds();
    SegmentManager().track(
      event: SegmentEvents.MODULE_CLICK_PRINTER_SETTINGS,
      properties: {
        'brand_ids': brandIds.toString(),
        'branch_ids': SessionManager().branchIDs().toString(),
        'business_id': SessionManager().businessID(),
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
        appBar: AppBar(title: Text(AppStrings.settings.tr()), elevation: 0, shadowColor: AppColors.greyBright),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Divider(thickness: 8.rh, color: AppColors.greyBright),
              Padding(padding: EdgeInsets.fromLTRB(16.rw, 16.rh, 16.rw, 20.rh), child: const AccountHeader()),
              Divider(thickness: 8.rh, color: AppColors.greyBright),
              Padding(
                padding: EdgeInsets.fromLTRB(AppSize.s16.rh, AppSize.s16.rw, AppSize.s16.rh, AppSize.s24.rw),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.account.tr(),
                      style: semiBoldTextStyle(
                        color: AppColors.neutralB500,
                        fontSize: AppSize.s16.rSp,
                      ),
                    ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: 16.rh),
                    ActionableTile(
                      title: AppStrings.edit_profile.tr(),
                      prefixWidget: ImageResourceResolver.profileSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.editProfile);
                      },
                    ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: 8.rh),
                    ActionableTile(
                      title: AppStrings.change_password.tr(),
                      prefixWidget: ImageResourceResolver.changePasswordSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.changePassword);
                      },
                    ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: 8.rh),
                    Text(
                      'Preferences',
                      style: semiBoldTextStyle(
                        color: AppColors.neutralB500,
                        fontSize: AppSize.s16.rSp,
                      ),
                    ).setVisibilityWithSpace(startSpace: 16.rh, direction: Axis.vertical, endSpace: 16.rh),
                    const NotificationSettingScreen().setVisibilityWithSpace(direction: Axis.vertical, endSpace: 8.rh),
                    ActionableTile(
                      title: AppStrings.change_language.tr(),
                      prefixWidget: ImageResourceResolver.languageSVG.getImageWidget(width: 20.rw, height: 20.rh, color: AppColors.neutralB600),
                      suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      onTap: _onLanguageChange,
                    ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: 8.rh),
                    Text(
                      'Devices',
                      style: semiBoldTextStyle(
                        color: AppColors.neutralB500,
                        fontSize: AppSize.s16.rSp,
                      ),
                    ).setVisibilityWithSpace(startSpace: 16.rh, direction: Axis.vertical, endSpace: 16.rh),
                    ActionableTile(
                      title: AppStrings.printer_settings.tr(),
                      prefixWidget: ImageResourceResolver.printerSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      onTap: () {
                        trackPrinterSettingsClickEvent();

                        Navigator.of(context).pushNamed(Routes.printerSettings);
                      },
                    ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: 8.rh),
                    ActionableTile(
                      title: AppStrings.device_setting.tr(),
                      prefixWidget: ImageResourceResolver.phoneSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      onTap: _onDeviceChange,
                    ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: 8.rh),
                    ActionableTile(
                      title: AppStrings.contact_support.tr(),
                      prefixWidget: ImageResourceResolver.supportSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.contactSupport);
                      },
                    ).setVisibilityWithSpace(startSpace: 16.rh, direction: Axis.vertical, endSpace: 20.rh),
                    AppVersionInfo().setVisibilityWithSpace(direction: Axis.vertical, endSpace: 24.rh),
                    BlocConsumer<LogoutCubit, CubitState>(
                      listener: (context, state) {
                        logoutButtonController.setLoaded(state is! Loading);

                        if (state is Failed) {
                          showApiErrorSnackBar(context, state.failure);
                        } else if (state is Success<SuccessResponse>) {
                          showSuccessSnackBar(context, state.data.message);
                          SegmentManager().identify(event: SegmentEvents.USER_LOGGED_OUT);
                          SessionManager().logout();
                        }
                      },
                      builder: (context, state) {
                        return KTButton(
                          controller: logoutButtonController,
                          prefixWidget: ImageResourceResolver.logoutSVG.getImageWidget(width: 20.rw, height: 20.rh),
                          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.greyBright),
                          labelStyle: mediumTextStyle(),
                          splashColor: AppColors.greyBright,
                          onTap: () async {
                            _showLogoutDialog(context);
                          },
                        );
                      },
                    ),
                    const ConsumerProtectionView(
                      loggedIn: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    logoutButtonController.dispose();
    super.dispose();
  }
}
