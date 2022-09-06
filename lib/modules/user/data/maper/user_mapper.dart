import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/user/data/models/success_response.dart';
import 'package:klikit/modules/user/data/models/user_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';

User mapUserModelToUser(UserModel userModel){
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
      businessName: userModel.user?.business_name?.orEmpty() ?? EMPTY,
      brandName: userModel.user?.brand_name?.orEmpty() ?? EMPTY,
      branchName: userModel.user?.branch_name?.orEmpty() ?? EMPTY,
      businessId: userModel.user?.business_id?.orZero() ?? ZERO,
      brandId: userModel.user?.brand_id?.orZero() ?? ZERO,
      branchId: userModel.user?.branch_id?.orZero() ?? ZERO,
      createdAt: userModel.user?.created_at?.orEmpty() ?? EMPTY,
      lastLoginAt: userModel.user?.last_login_at?.orEmpty() ?? EMPTY,
      firstLogin: userModel.user?.first_login ?? false,
      roles: userModel.user?.roles ?? [],
      roleIds: userModel.user?.role_ids ?? [],
      displayRoles: userModel.user?.display_roles ?? [],
      updatedAt:  userModel.user?.updated_at?.orEmpty() ?? EMPTY,
      permissions: userModel.user?.permissions ?? [],
      countryCodes: userModel.user?.country_codes ?? [],
      countryIds: userModel.user?.country_ids ?? [],
    ),
  );
}

SuccessResponse mapSuccessResponse(SuccessResponseModel responseModel){
  return SuccessResponse(responseModel.message ?? EMPTY);
}