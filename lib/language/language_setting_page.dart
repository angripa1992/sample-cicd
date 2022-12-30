import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/language/language_manager.dart';
import 'package:klikit/resources/values.dart';

import '../resources/colors.dart';
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
  late GlobalKey _dropdownKey;
  String? _dropDownValue;

  @override
  void initState() {
    _dropdownKey = GlobalKey();
    _dropDownValue = _languageManager.currentLanguageCode();
    super.initState();
  }

  void _changeLocale(Language language){
    context.setLocale(_languageManager.makeLocaleFromLanguage(language));
    _languageManager.saveCurrentLanguageCode(language.code!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.change_language.tr()),
        titleTextStyle: getAppBarTextStyle(),
        centerTitle: true,
        flexibleSpace: getAppBarBackground(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.s20.rh,
              horizontal: AppSize.s20.rw,
            ),
            child: const Text('Select Language'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s20.rw),
            child: FutureBuilder<List<Language>>(
              future: _languageManager.getSupportedLanguages(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  final languages = snapshot.data!;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                      color: AppColors.lightVioletTwo,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
                      child: DropdownButton<String>(
                        key: _dropdownKey,
                        value: _dropDownValue,
                        isExpanded: true,
                        underline: const SizedBox(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.purpleBlue,
                        ),
                        selectedItemBuilder: (BuildContext context) {
                          return languages.map<Widget>((item) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.title!,
                              ),
                            );
                          }).toList();
                        },
                        items: languages.map<DropdownMenuItem<String>>(
                          (language) {
                            return DropdownMenuItem<String>(
                              value: language.code,
                              child: RadioListTile<String>(
                                title: Text(language.title!),
                                value: language.code!,
                                groupValue: _dropDownValue,
                                activeColor: AppColors.purpleBlue,
                                onChanged: (value) {
                                  Navigator.pop(_dropdownKey.currentContext!);
                                  setState(() {
                                    _dropDownValue = value;
                                    _changeLocale(languages.firstWhere((element) => element.code == value));
                                  });
                                },
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {},
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
