import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/styles.dart';

import '../../resources/colors.dart';
import 'kt_network_image.dart';

class KTRadioValue {
  final int id;
  final String title;
  final String? logo;
  String? subTitle;
  IconData? editableIcon;

  KTRadioValue(
    this.id,
    this.title, {
    this.subTitle,
    this.editableIcon,
    this.logo,
  });

  set subtitle(String value) {
    subTitle = value;
  }

  set icon(IconData iconData) {
    editableIcon = iconData;
  }

  @override
  String toString() {
    return 'id = $id, title = $title, logo = $logo';
  }
}

class KTRadioGroup extends StatefulWidget {
  final List<KTRadioValue> values;
  final int? initiallySelectedButtonID;
  final Function(KTRadioValue) onChangedCallback;
  final Function(KTRadioValue)? onEditItemValue;

  const KTRadioGroup({
    super.key,
    required this.values,
    required this.initiallySelectedButtonID,
    required this.onChangedCallback,
    this.onEditItemValue,
  });

  @override
  State<KTRadioGroup> createState() => _KTRadioGroupState();
}

class _KTRadioGroupState extends State<KTRadioGroup> {
  int? _selectedButtonID;

  void _setInitValue() {
    _selectedButtonID = widget.initiallySelectedButtonID;
  }

  @override
  void initState() {
    _setInitValue();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant KTRadioGroup oldWidget) {
    _setInitValue();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.values.map((value) {
        return value.logo != null
            ? ListTile(
                leading: SizedBox(
                  width: 32.rSp,
                  height: 32.rSp,
                  child: KTNetworkImage(
                    imageUrl: value.logo!,
                    width: 32.rSp,
                    height: 32.rSp,
                  ),
                ),
                title: _title(value),
                trailing: _radioButton(value),
              )
            : ListTile(
                title: _title(value),
                trailing: _radioButton(value),
              );
      }).toList(),
    );
  }

  Widget _title(KTRadioValue value) {
    return Row(
      children: [
        Flexible(
          child: Text(
            value.title,
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: 14.rSp,
            ),
          ),
        ),
        if (value.subTitle != null)
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.rw),
              child: Text(
                value.subTitle!,
                style: mediumTextStyle(
                  color: AppColors.neutralB100,
                  fontSize: 14.rSp,
                ),
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
    );
  }

  Widget _radioButton(KTRadioValue value) {
    return Radio<int>(
      activeColor: AppColors.primary,
      value: value.id,
      groupValue: _selectedButtonID,
      onChanged: (id) {
        setState(() {
          _selectedButtonID = id;
          widget.onChangedCallback(value);
        });
      },
    );
  }
}
