import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/styles.dart';

import '../../resources/colors.dart';

class KTRadioValue {
  final int id;
  final String title;
  final String? logo;

  KTRadioValue(this.id, this.title, {this.logo});

  @override
  String toString() {
    return 'id = $id, title = $title, logo = $logo';
  }
}

class KTRadioGroup extends StatefulWidget {
  final List<KTRadioValue> values;
  final int initiallySelectedButtonID;
  final Function(KTRadioValue) onChangedCallback;

  const KTRadioGroup({
    super.key,
    required this.values,
    required this.initiallySelectedButtonID,
    required this.onChangedCallback,
  });

  @override
  State<KTRadioGroup> createState() => _KTRadioGroupState();
}

class _KTRadioGroupState extends State<KTRadioGroup> {
  int? _selectedButtonID;

  @override
  void initState() {
    _selectedButtonID = widget.initiallySelectedButtonID;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.values.map((value) {
        return ListTile(
          title: Text(
            value.title,
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: 14.rSp,
            ),
          ),
          trailing: Radio<int>(
            activeColor: AppColors.primary,
            value: value.id,
            groupValue: _selectedButtonID,
            onChanged: (id) {
              setState(() {
                _selectedButtonID = id;
                widget.onChangedCallback(value);
              });
            },
          ),
        );
      }).toList(),
    );
  }
}
