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

void showLanguageSettingDialog({
  required BuildContext context,
  required Function(Locale,int) onLanguageChange,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(AppSize.ZERO),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
        content: LanguageSettingPage(onLanguageChange: onLanguageChange),
      );
    },
  );
}

class LanguageSettingPage extends StatefulWidget {
  final Function(Locale,int) onLanguageChange;

  const LanguageSettingPage({Key? key, required this.onLanguageChange})
      : super(key: key);

  @override
  State<LanguageSettingPage> createState() => _LanguageSettingPageState();
}

class _LanguageSettingPageState extends State<LanguageSettingPage> {
  final _languageManager = getIt.get<LanguageManager>();
  int? _currentLanguageId;
  Language? _currentLanguage;

  @override
  void initState() {
    _currentLanguageId = _languageManager.currentLanguageId();
    super.initState();
  }

  void _changeLocale() {
    if (_currentLanguage != null && _currentLanguageId != null) {
      final locale = _languageManager.makeLocaleFromLanguage(_currentLanguage!);
      widget.onLanguageChange(locale,_currentLanguageId!);
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
                      child: RadioListTile<int>(
                        contentPadding: const EdgeInsets.all(AppSize.ZERO),
                        title: Text(languages[index].title!),
                        value: languages[index].id!,
                        groupValue: _currentLanguageId,
                        activeColor: AppColors.pink,
                        onChanged: (value) {
                          setState(() {
                            _currentLanguageId = value;
                            _currentLanguage = languages.firstWhere((element) => element.id == value);
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
