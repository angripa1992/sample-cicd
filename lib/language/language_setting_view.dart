import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/language/language_manager.dart';

import '../resources/colors.dart';
import 'language.dart';

class LanguageSettingView extends StatefulWidget {
  const LanguageSettingView({Key? key}) : super(key: key);

  @override
  State<LanguageSettingView> createState() => _LanguageSettingViewState();
}

class _LanguageSettingViewState extends State<LanguageSettingView> {
  final _languageManager = getIt.get<LanguageManager>();
  late GlobalKey _dropdownKey;
  String? _dropDownValue;

  @override
  void initState() {
    _dropdownKey = GlobalKey();
    _dropDownValue = _languageManager.currentLanguageCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Change Language'),
          FutureBuilder<List<Language>>(
            future: _languageManager.getSupportedLanguages(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final languages = snapshot.data!;
                return DropdownButton<String>(
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
                  items: languages.map<DropdownMenuItem<String>>((language) {
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
                            });
                          },
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {},
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
