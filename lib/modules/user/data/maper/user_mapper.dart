import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/user/data/models/success_response.dart';
import 'package:klikit/modules/user/data/models/user_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';

User mapUserModelToUser(UserModel userModel) {
  return User(
    accessToken: userModel.access_token.orEmpty(),
    refreshToken: userModel.refresh_token.orEmpty(),
    userInfo: UserInfo(
      id: userModel.user?.id?.orZero() ?? ZERO,
      firstName: userModel.user?.first_name?.orEmpty() ?? EMPTY,
      lastName: userModel.user?.last_name?.orEmpty() ?? EMPTY,
      email: userModel.user?.email?.orEmpty() ?? EMPTY,
      phone: userModel.user?.phone?.orEmpty() ?? EMPTY,
      profilePic: userModel.user?.profile_pic?.orEmpty() ?? EMPTY,
      businessId: userModel.user?.business_id?.orZero() ?? ZERO,
      businessName: userModel.user?.business_name?.orEmpty() ?? EMPTY,
      firstLogin: userModel.user?.first_login ?? false,
      orderNotificationEnabled: userModel.user?.order_notification_enabled ?? true,
      printingDeviceId: userModel.user?.printing_device_id ?? Device.android,
      branchIDs: userModel.user?.branch_ids ?? [],
      branchTitles: userModel.user?.branch_titles ?? [],
      roles: userModel.user?.roles ?? [],
      roleIds: userModel.user?.role_ids ?? [],
      displayRoles: userModel.user?.display_roles ?? [],
      permissions: userModel.user?.permissions ?? [],
      countryCodes: userModel.user?.country_codes ?? [],
      countryIds: userModel.user?.country_ids ?? [],
      brandIDs: userModel.user?.brand_ids ?? [],
      brandTitles: userModel.user?.brand_titles ?? [],
      menuV2Enabled: userModel.user?.menuv2_enabled ?? false,
      menuVersion: userModel.user?.menu_version ?? MenuVersion.v1,
      menuV2EnabledForKlikitOrder: userModel.user?.menuv2_enabled_for_klikit_order ?? false,
      menuVersionForKlikitOrder: userModel.user?.menu_version_for_klikit_order ?? MenuVersion.v1,
    ),
  );
}

SuccessResponse mapSuccessResponse(SuccessResponseModel responseModel) {
  return SuccessResponse(responseModel.message ?? EMPTY);
}
