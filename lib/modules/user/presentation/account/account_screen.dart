import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/core/widgets/actionable_tile.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/kt_switch.dart';
import 'package:klikit/core/widgets/modal_sheet_manager.dart';
import 'package:klikit/core/widgets/popups.dart';
import 'package:klikit/language/selected_locale.dart';
import 'package:klikit/modules/base/chnage_language_cubit.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/common/data/business_info_provider_repo.dart';
import 'package:klikit/modules/support/contact_support.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/presentation/account/component/add_delivery_time_view.dart';
import 'package:klikit/modules/user/presentation/account/component/device_setting_view.dart';
import 'package:klikit/modules/user/presentation/account/component/notification_setting_dialog.dart';
import 'package:klikit/modules/user/presentation/account/cubit/auto_accept_order_cubit.dart';
import 'package:klikit/modules/user/presentation/account/cubit/logout_cubit.dart';
import 'package:klikit/modules/widgets/negative_button.dart';
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
import '../../../../language/language_setting_page.dart';
import '../../../../resources/fonts.dart';
import '../../../../segments/segemnt_data_provider.dart';
import '../../../widgets/snackbars.dart';
import 'component/account_header.dart';
import 'component/app_version_info.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _businessInfoProvider = getIt.get<BusinessInformationProvider>();
  late final logoutButtonController = KTButtonController(label: AppStrings.logout.tr());
  final _controller = ValueNotifier<bool>(false);
  final _autoAcceptController = ValueNotifier<bool>(false);
  final _autoAcceptCubit = getIt.get<AutoAcceptOrderCubit>();

  @override
  void initState() {
    _controller.value = SessionManager().notificationEnable();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!UserPermissionManager().isBizOwner()) {
        _autoAcceptCubit.fetchPreference();
      }
    });

    SegmentManager().screen(
      event: SegmentEvents.ACCOUNT_TAB,
      name: 'Account Tab',
    );
    super.initState();
  }

  void _onLanguageChange() {
    ModalSheetManager.openBottomSheet(
      context,
      Padding(
        padding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, bottom: 20.rh),
        child: const LanguageSettingPage(),
      ),
      title: AppStrings.select_language.tr(),
      dismissible: false,
    ).then(
      (value) async {
        if (value is SelectedLocale) {
          /// TODO: Should have a better solution
          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            context.read<ChangeLanguageCubit>().openLanguageSettingDialog(value);
          }
        }
      },
    );
  }

  void _onDeviceChange() {
    ModalSheetManager.openBottomSheet(
      context,
      Padding(
        padding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, bottom: 20.rh),
        child: const DeviceSettingScreen(),
      ),
      title: AppStrings.device_setting.tr(),
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

  Future<void> _onAddDeliveryTime() async {
    EasyLoading.show();
    final response = await getIt.get<BusinessInfoProviderRepo>().fetchDeliveryTime(SessionManager().branchId());
    EasyLoading.dismiss();
    response.fold(
      (error) {
        showErrorSnackBar(context, error.message);
      },
      (data) {
        showDialog(
          context: context,
          builder: (ct) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.rSp))),
            content: AddDeliveryTimeView(initialDeliveryTime: data.deliveryTimeMinute),
          ),
        );
      },
    );
  }

  void _onContactSupport() {
    ModalSheetManager.openBottomSheet(
      context,
      Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
        child: const ContactSupportScreen(),
      ),
      title: AppStrings.contact_support.tr(),
      dismissible: false,
    ).then(
      (value) {
        if (value is String) {
          showApiErrorSnackBar(context, Failure(ResponseCode.DEFAULT, value));
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
          content: Text(
            AppStrings.logout_confirm_message.tr(),
            textAlign: TextAlign.center,
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          actionsAlignment: MainAxisAlignment.end,
          actionsPadding: EdgeInsets.only(
            right: AppSize.s16.rw,
            left: AppSize.s16.rw,
            bottom: AppSize.s16.rh,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: NegativeButton(negativeText: AppStrings.cancel.tr()),
                ),
                SizedBox(width: AppSize.s12.rw),
                Expanded(
                  child: KTButton(
                    controller: KTButtonController(label: AppStrings.logout.tr()),
                    backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.errorR300),
                    labelStyle: mediumTextStyle(color: AppColors.white),
                    onTap: () {
                      Navigator.of(dContext).pop();
                      context.read<LogoutCubit>().logout();
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void trackPrinterSettingsClickEvent() async {
    final brandIds = await _businessInfoProvider.fetchBrandsIds();
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
        appBar: AppBar(title: Text(AppStrings.account.tr()), elevation: 0, shadowColor: AppColors.greyBright),
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
                    ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s16),
                    ActionableTile(
                      title: AppStrings.edit_profile.tr(),
                      prefixWidget: ImageResourceResolver.profileSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.editProfile);
                      },
                    ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s8),
                    ActionableTile(
                      title: AppStrings.change_password.tr(),
                      prefixWidget: ImageResourceResolver.changePasswordSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.changePassword);
                      },
                    ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s8),
                    Text(
                      AppStrings.preferences.tr(),
                      style: semiBoldTextStyle(
                        color: AppColors.neutralB500,
                        fontSize: AppSize.s16.rSp,
                      ),
                    ).setVisibilityWithSpace(startSpace: 16.rh, direction: Axis.vertical, endSpace: 16.rh),
                    if (!UserPermissionManager().isBizOwner())
                      ActionableTile(
                        title: AppStrings.notification.tr(),
                        prefixWidget: ImageResourceResolver.notificationSVG.getImageWidget(width: 20.rw, height: 20.rh),
                        suffixWidget: KTSwitch(
                          controller: _controller,
                          onChanged: (enabled) {
                            showPauseNotificationConfirmationDialog(
                              context: context,
                              enable: enabled,
                              onSuccess: () {
                                _controller.value = enabled;
                              },
                            );
                          },
                          height: 18.rh,
                          width: 36.rw,
                        ),
                      ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: 8.rh),
                    ActionableTile(
                      title: AppStrings.change_language.tr(),
                      prefixWidget: ImageResourceResolver.languageSVG.getImageWidget(width: 20.rw, height: 20.rh, color: AppColors.neutralB600),
                      suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 20.rw, height: 20.rh),
                      onTap: _onLanguageChange,
                    ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s8),

                    if (!UserPermissionManager().isBizOwner())
                      BlocProvider(
                        create: (context) => _autoAcceptCubit,
                        child: BlocBuilder<AutoAcceptOrderCubit, AutoAcceptState>(
                          builder: (context, state) {
                            if (state is FetchedState) {
                              _autoAcceptController.value = state.success.autoAccept;
                            }

                            return ActionableTile(
                              title: AppStrings.auto_accept_orders.tr(),
                              subtitle: AppStrings.auto_accept_aggregator_orders.tr(),
                              prefixWidget: ImageResourceResolver.autoAcceptSVG.getImageWidget(width: 20.rw, height: 20.rh, color: AppColors.neutralB600),
                              suffixWidget: KTSwitch(
                                controller: _autoAcceptController,
                                onChanged: (enabled) {
                                  autoAcceptDialog(context, enabled, onSuccess: () {
                                    _autoAcceptController.value = enabled;
                                  });
                                },
                                height: 18.rh,
                                width: 36.rw,
                              ),
                            ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: 8.rh);
                          },
                        ),
                      ),

                    //delivery time config only enabled for japan branch manager
                    if (!UserPermissionManager().isBizOwner() && (SessionManager().countryCode() == CountryCode.japan || SessionManager().countryCode() == CountryCode.japan.toISO()))
                      ActionableTile(
                        title: 'Average Delivery Time',
                        subtitle: 'Average time required to deliver food',
                        prefixWidget: ImageResourceResolver.riderSVG.getImageWidget(width: 20.rSp, height: 20.rSp, color: AppColors.neutralB600),
                        suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 20.rw, height: 20.rh),
                        onTap: () {
                          _onAddDeliveryTime();
                        },
                      ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s8),

                    Text(
                      AppStrings.devices.tr(),
                      style: semiBoldTextStyle(
                        color: AppColors.neutralB500,
                        fontSize: AppSize.s16.rSp,
                      ),
                    ).setVisibilityWithSpace(startSpace: 16.rh, direction: Axis.vertical, endSpace: !UserPermissionManager().isBizOwner() ? 16.rh : 0),
                    if (!UserPermissionManager().isBizOwner())
                      ActionableTile(
                        title: AppStrings.printer_settings.tr(),
                        prefixWidget: ImageResourceResolver.printerSVG.getImageWidget(width: 20.rw, height: 20.rh),
                        suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 20.rw, height: 20.rh),
                        onTap: () {
                          trackPrinterSettingsClickEvent();

                          Navigator.of(context).pushNamed(Routes.printerSettings);
                        },
                      ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: 8.rh),
                    if (!UserPermissionManager().isBizOwner())
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
                      onTap: _onContactSupport,
                    ).setVisibilityWithSpace(startSpace: AppSize.s16, direction: Axis.vertical, endSpace: AppSize.s20),
                    AppVersionInfo().setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s24),
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
                        logoutButtonController.label = AppStrings.logout.tr();
                        return KTButton(
                          controller: logoutButtonController,
                          // prefixWidget: ImageResourceResolver.logoutSVG.getImageWidget(width: 20.rw, height: 20.rh),
                          prefixWidget: Icon(Icons.logout, color: AppColors.redDark, size: AppSize.s24.rSp),
                          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.greyBright),
                          labelStyle: mediumTextStyle(),
                          splashColor: AppColors.greyBright,
                          onTap: () async {
                            _showLogoutDialog(context);
                          },
                        );
                      },
                    ),
                    const ConsumerProtectionView(loggedIn: true),
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
