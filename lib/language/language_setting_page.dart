import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
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
  required Function(Locale, int) onLanguageChange,
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
  final Function(Locale, int) onLanguageChange;

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
      widget.onLanguageChange(locale, _currentLanguageId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: AppSize.s16.rh,
              bottom: AppSize.s8.rh,
            ),
            child: Text(
              AppStrings.select_language.tr(),
              style: mediumTextStyle(
                color: AppColors.primary,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
          ),
          const Divider(),
          FutureBuilder<List<Language>>(
            future: _languageManager.getSupportedLanguages(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final languages = snapshot.data!;
                return Column(
                  children: languages.map((language) {
                    return RadioListTile<int>(
                      contentPadding: const EdgeInsets.all(AppSize.ZERO),
                      title: Text(
                        language.title!,
                        style: regularTextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.s14.rSp,
                        ),
                      ),
                      value: language.id!,
                      groupValue: _currentLanguageId,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _currentLanguageId = value;
                          _currentLanguage = languages
                              .firstWhere((element) => element.id == value);
                        });
                      },
                    );
                  }).toList(),
                );
              }
              return const SizedBox();
            },
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.only(bottom: AppSize.s8.rh),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.cancel.tr(),
                      style: regularTextStyle(
                        color: AppColors.redDark,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSize.s16.rh),
                Expanded(
                  child: AppButton(
                    enable: true,
                    onTap: () {
                      _changeLocale();
                      Navigator.pop(context);
                    },
                    text: AppStrings.select.tr(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
