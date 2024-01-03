import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/styles.dart';

import '../../resources/colors.dart';

class KTRadioValue {
  final int id;
  final String title;
  final String? logo;
  final String? subTitle;
  final IconData? editableIcon;

  KTRadioValue(
    this.id,
    this.title, {
    this.subTitle,
    this.editableIcon,
    this.logo,
  });

  set subtitle(String value){

  }

  @override
  String toString() {
    return 'id = $id, title = $title, logo = $logo';
  }
}

class KTRadioGroup extends StatefulWidget {
  final List<KTRadioValue> values;
  final int initiallySelectedButtonID;
  final Function(KTRadioValue) onChangedCallback;
  final Function(KTRadioValue)? onEditItemValue;

  const KTRadioGroup({
    super.key,
    required this.values,
    required this.initiallySelectedButtonID,
    required this.onChangedCallback,
    required this.onEditItemValue,
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
          title: Row(
            children: [
              Text(
                value.title,
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: 14.rSp,
                ),
              ),
              if (value.subTitle != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.rw),
                  child: Text(
                    value.subTitle!,
                    style: mediumTextStyle(
                      color: AppColors.neutralB100,
                      fontSize: 14.rSp,
                    ),
                  ),
                ),
              if (value.editableIcon != null)
                InkWell(
                  onTap: () {
                    if (widget.onEditItemValue != null) {
                      widget.onEditItemValue!(value);
                    }
                  },
                  child: Icon(
                    value.editableIcon!,
                    size: 18.rSp,
                    color: AppColors.primary,
                  ),
                ),
            ],
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
