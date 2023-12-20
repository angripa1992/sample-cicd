import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/resources/strings.dart';

class KTDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T item) titleBuilder;
  final void Function(T selectedItem) onSelected;
  final T? selectedItem;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final BoxDecoration? backgroundDecoration;
  final DecoratedImageView? trailingWidget;
  final String? hintText;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;

  const KTDropdown(
      {super.key,
      required this.items,
      required this.titleBuilder,
      required this.onSelected,
      this.selectedItem,
      this.padding,
      this.borderRadius,
      this.backgroundDecoration,
      this.trailingWidget,
      this.hintText,
      this.textStyle,
      this.hintTextStyle});

  @override
  State<KTDropdown<T>> createState() => _KTDropdownState<T>();
}

class _KTDropdownState<T> extends State<KTDropdown<T>> {
  int? selectedItemIndex;

  @override
  void initState() {
    super.initState();
    selectedItemIndex = refreshSelection();
  }

  @override
  void didUpdateWidget(covariant KTDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedItemIndex = refreshSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: widget.backgroundDecoration,
      child: DropdownButton<T>(
        isExpanded: true,
        menuMaxHeight: 384,
        underline: const SizedBox(
          width: 0,
          height: 0,
        ),
        icon: widget.trailingWidget,
        borderRadius: widget.borderRadius,
        alignment: Alignment.centerLeft,
        hint: Text(
          widget.hintText ?? AppStrings.select.tr(),
          style: widget.hintTextStyle,
        ),
        items: widget.items.map<DropdownMenuItem<T>>(
          (currentData) {
            return DropdownMenuItem(
              value: currentData,
              child: Text(
                widget.titleBuilder(currentData),
                style: widget.textStyle,
              ),
            );
          },
        ).toList(),
        onChanged: (T? value) {
          if (value != null) {
            widget.onSelected(value);

            setState(() {
              selectedItemIndex = findItemIndex(value);
            });
          }
        },
        value: selectedItemIndex != null ? widget.items[selectedItemIndex!] : null,
      ),
    );
  }

  int? refreshSelection() {
    if (widget.selectedItem != null) {
      return findItemIndex(widget.selectedItem as T);
    } else {
      return selectedItemIndex;
    }
  }

  int? findItemIndex(T value) {
    int index = widget.items.indexOf(value);
    return index != -1 ? index : null;
  }
}
