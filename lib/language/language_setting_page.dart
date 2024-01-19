import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/language/language_manager.dart';
import 'package:klikit/language/selected_locale.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/values.dart';

import '../resources/colors.dart';
import '../resources/fonts.dart';
import '../resources/strings.dart';
import '../resources/styles.dart';
import 'language.dart';

class LanguageSettingPage extends StatefulWidget {
  const LanguageSettingPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder<List<Language>>(
          future: _languageManager.getSupportedLanguages(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final languages = snapshot.data!;
              return Column(
                children: languages.map((language) {
                  return RadioListTile<int>(
                    contentPadding: EdgeInsets.fromLTRB(12.rw, 0, 8.rw, 0),
                    selected: _currentLanguageId == language.id,
                    selectedTileColor: AppColors.neutralB20,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.rSp)),
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Row(
                      children: buildTileContents(language),
                    ),
                    value: language.id!,
                    groupValue: _currentLanguageId,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        _currentLanguageId = value;
                        _currentLanguage = languages.firstWhere((element) => element.id == value);
                      });
                    },
                  );
                }).toList(),
              );
            }
            return const SizedBox();
          },
        ),
        KTButton(
          controller: KTButtonController(label: AppStrings.update.tr()),
          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP300),
          labelStyle: mediumTextStyle(color: AppColors.white),
          verticalContentPadding: 10.rh,
          onTap: () {
            if (_currentLanguage != null && _currentLanguageId != null) {
              final locale = _languageManager.makeLocaleFromLanguage(_currentLanguage!);
              Navigator.pop(context, SelectedLocale(_currentLanguageId!, locale));
            }
          },
        ).setVisibilityWithSpace(direction: Axis.vertical, startSpace: AppSize.s16),
      ],
    );
  }

  List<Widget> buildTileContents(Language language) {
    final flags = language.getFlagResources();
    List<Widget> list = [];
    list.add(
      Expanded(
        child: Text(
          language.title!,
          style: regularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ),
    );

    for (final flag in flags) {
      list.add(flag.getImageWidget(width: 28.rw, height: 20.rh).setVisibilityWithSpace(
        direction: Axis.horizontal,
            startSpace: 8,
          ));
    }

    return list;
  }
}
