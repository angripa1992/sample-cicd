import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/modules/user/data/request_model/reset_link_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/presentation/forget/cubit/forget_cubit.dart';
import 'package:klikit/modules/user/presentation/login/components/input_feild.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/modules/widgets/url_text_button.dart';
import 'package:klikit/resources/fonts.dart';

import '../../../../app/constants.dart';
import '../../../../app/size_config.dart';
import '../../../../core/route/routes.dart';
import '../../../../resources/assets.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/strings.dart';
import '../../../../resources/styles.dart';
import '../../../../resources/values.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({Key? key}) : super(key: key);

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _validateAndSentResetLink(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context
          .read<ForgetPasswordCubit>()
          .sendResetPasswordLink(ResetLinkRequestModel(_emailController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<ForgetPasswordCubit>(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.black,
          body: SingleChildScrollView(
            child: Container(
              height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight,
              width: ScreenSizes.screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(AppImages.loginBG),
                  colorFilter: ColorFilter.mode(
                      AppColors.black.withOpacity(0.3), BlendMode.dstATop),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s28.rw,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppStrings.password_reset_page.tr(),
                              style: getMediumTextStyle(
                                color: AppColors.black,
                                fontSize: AppSize.s24.rSp,
                              ),
                            ),
                            UrlTextButton(
                              text: AppStrings.dont_have_account.tr(),
                              color: AppColors.black,
                              fontWeight: AppFontWeight.bold,
                              textSize: AppSize.s14.rSp,
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  Routes.webView,
                                  arguments: AppConstant.signUpUrl,
                                );
                              },
                            ),
                            SizedBox(height: AppSize.s32.rh),
                            Form(
                              key: _formKey,
                              child: InputField(
                                label: AppStrings.email.tr(),
                                controller: _emailController,
                                inputType: TextInputType.emailAddress,
                                isPasswordField: false,
                                hintText: AppStrings.type_your_email_here.tr(),
                                labelColor: AppColors.smokeyGrey,
                                textColor: AppColors.smokeyGrey,
                                borderColor: AppColors.smokeyGrey,
                              ),
                            ),
                            SizedBox(height: AppSize.s42.rh),
                            BlocConsumer<ForgetPasswordCubit, CubitState>(
                              builder: (context, state) {
                                return LoadingButton(
                                  isLoading: (state is Loading),
                                  text: AppStrings.sent_reset_link.tr(),
                                  verticalPadding: AppSize.s12.rh,
                                  onTap: () {
                                    _validateAndSentResetLink(context);
                                  },
                                );
                              },
                              listener: (context, state) {
                                if (state is Failed) {
                                  showErrorSnackBar(
                                      context, state.failure.message);
                                } else if (state is Success<SuccessResponse>) {
                                  showSuccessSnackBar(
                                      context, state.data.message);
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            SizedBox(height: AppSize.s24.rh),
                            UrlTextButton(
                              text: AppStrings.back_to_login.tr(),
                              color: AppColors.black,
                              fontWeight: AppFontWeight.bold,
                              onPressed: () {
                                Navigator.of(context).pop();
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
