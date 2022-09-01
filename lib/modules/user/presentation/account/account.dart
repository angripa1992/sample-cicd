import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/modules/user/presentation/account/component/edit_profile_textfield.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

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


  void _validateAndUpdate() {
    if (_formKey.currentState!.validate()){
     print('=============validated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  style: getRegularTextStyle(
                    fontFamily: AppFonts.Abel,
                    color: AppColors.purpleBlue,
                    fontSize: AppSize.s14.rSp,
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
                LoadingButton(
                  isLoading: false,
                  onTap: () {
                    _validateAndUpdate();
                  },
                  text: AppStrings.update.tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
