import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/strings.dart';
import '../../../../../resources/values.dart';
import 'input_feild.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const LoginForm({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          InputField(
            label: AppStrings.email.tr(),
            controller: emailController,
            inputType: TextInputType.emailAddress,
            obscureText: false,
          ),
          SizedBox(
            height: AppSize.s28.rh,
          ),
          InputField(
            label: AppStrings.password.tr(),
            controller: passwordController,
            inputType: TextInputType.text,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
