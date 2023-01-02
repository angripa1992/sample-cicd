import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/language/language_manager.dart';
import 'package:klikit/modules/widgets/app_button.dart';
import 'package:klikit/resources/values.dart';

import '../resources/colors.dart';
import '../resources/fonts.dart';
import '../resources/strings.dart';
import '../resources/styles.dart';
import 'language.dart';

void showLanguageSettingDialog({required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const AlertDialog(
        contentPadding: EdgeInsets.all(AppSize.ZERO),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
        content: LanguageSettingPage(),
      );
    },
  );
}

class LanguageSettingPage extends StatefulWidget {
  const LanguageSettingPage({Key? key}) : super(key: key);

  @override
  State<LanguageSettingPage> createState() => _LanguageSettingPageState();
}

class _LanguageSettingPageState extends State<LanguageSettingPage> {
  final _languageManager = getIt.get<LanguageManager>();
  String? _currentLanguageCode;
  Language? _currentLanguage;

  @override
  void initState() {
    _currentLanguageCode = _languageManager.currentLanguageCode();
    super.initState();
  }

  void _changeLocale() {
    if (_currentLanguage != null) {
      context.setLocale(
          _languageManager.makeLocaleFromLanguage(_currentLanguage!));
      _languageManager.saveCurrentLanguageCode(_currentLanguage!.code!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: AppSize.s16,
              bottom: AppSize.s8,
            ),
            child: Text(
              AppStrings.select_language.tr(),
              style: getMediumTextStyle(
                color: AppColors.purpleBlue,
                fontSize: AppFontSize.s16,
              ),
            ),
          ),
          FutureBuilder<List<Language>>(
            future: _languageManager.getSupportedLanguages(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final languages = snapshot.data!;
                return ListView.builder(
                  itemCount: languages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Theme(
                      data: ThemeData(
                        unselectedWidgetColor: AppColors.pink,
                      ),
                      child: RadioListTile<String>(
                        contentPadding: const EdgeInsets.all(AppSize.ZERO),
                        title: Text(languages[index].title!),
                        value: languages[index].code!,
                        groupValue: _currentLanguageCode,
                        activeColor: AppColors.pink,
                        onChanged: (value) {
                          setState(() {
                            _currentLanguageCode = value;
                            _currentLanguage = languages
                                .firstWhere((element) => element.code == value);
                          });
                        },
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSize.s8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppStrings.cancel.tr(),
                    style: getRegularTextStyle(
                      color: AppColors.purpleBlue,
                      fontSize: AppFontSize.s16,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.s16),
                AppButton(
                  enable: true,
                  onTap: () {
                    _changeLocale();
                    Navigator.pop(context);
                  },
                  text: AppStrings.select.tr(),
                  verticalPadding: AppSize.s8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
