import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/modules/user/data/request_model/user_update_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/modules/user/domain/usecases/update_user_info.dart';
import 'package:klikit/modules/user/presentation/account/component/edit_profile_textfield.dart';
import 'package:klikit/modules/user/presentation/account/cubit/update_user_info_cubit.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/session_manager.dart';
import '../../../../../resources/styles.dart';
import '../../../../widgets/dialogs.dart';
import '../../../../widgets/snackbars.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNameController = TextEditingController();
  final _emailNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late UserInfo _user;

  @override
  void initState() {
    _user = SessionManager().user()!;
    _firstNameController.text = _user.firstName;
    _lastNameController.text = _user.lastName;
    _phoneNameController.text = _user.phone;
    _emailNameController.text = _user.email;
    super.initState();
  }

  void _validateAndUpdate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      bool isSameFirstName = _firstNameController.text == _user.firstName;
      bool isSameLastName = _lastNameController.text == _user.lastName;
      bool isSamePhone = _phoneNameController.text == _user.phone;
      if (isSameFirstName && isSameLastName && isSamePhone) {
        showValidationDialog(
          context: context,
          title: AppStrings.invalid_information.tr(),
          message: AppStrings.same_value_validation_message.tr(),
          onOK: () {},
        );
      } else {
        context.read<UpdateUserInfoCubit>().updateUserInfo(
              UpdateUserInfoParams(
                UserUpdateRequestModel(
                  branchId: _user.brandIDs.first,
                  businessId: _user.businessId,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  phone: _phoneNameController.text,
                  roleIds: _user.roleIds,
                  countryIds: _user.countryIds,
                ),
                _user.id,
              ),
            );
      }
    }
  }

  void _saveUpdatedUserInfo() async {
    await SessionManager().saveUser(
      _user.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneNameController.text,
      ),
    );
    setState(() {
      _user = SessionManager().user()!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<UpdateUserInfoCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.edit_profile.tr()),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s16.rw,
                  vertical: AppSize.s16.rh,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      EditProfileTextField(
                        currentValue: _user.firstName,
                        label: AppStrings.first_name.tr(),
                        editingController: _firstNameController,
                        enabled: true,
                      ),
                      SizedBox(height: AppSize.s23.rh),
                      EditProfileTextField(
                        currentValue: _user.lastName,
                        label: AppStrings.last_name.tr(),
                        editingController: _lastNameController,
                        enabled: true,
                      ),
                      SizedBox(height: AppSize.s23.rh),
                      EditProfileTextField(
                        currentValue: _user.phone,
                        label: AppStrings.contact_number.tr(),
                        editingController: _phoneNameController,
                        enabled: true,
                        inputType: TextInputType.phone,
                      ),
                      SizedBox(height: AppSize.s23.rh),
                      EditProfileTextField(
                        currentValue: _user.email,
                        label: AppStrings.email_address.tr(),
                        editingController: _emailNameController,
                        enabled: false,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s16.rw,
                  vertical: AppSize.s16.rh,
                ),
                child: BlocConsumer<UpdateUserInfoCubit, CubitState>(
                  listener: (context, state) {
                    if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    } else if (state is Success<SuccessResponse>) {
                      showSuccessSnackBar(context, state.data.message);
                      _saveUpdatedUserInfo();
                    }
                  },
                  builder: (context, state) {
                    return LoadingButton(
                      isLoading: (state is Loading),
                      text: AppStrings.update.tr(),
                      onTap: () {
                        _validateAndUpdate(context);
                      },
                    );
                  },
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNameController.dispose();
    _emailNameController.dispose();
    super.dispose();
  }
}
