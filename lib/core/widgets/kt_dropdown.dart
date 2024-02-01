import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/core/widgets/child_size_notifier.dart';
import 'package:klikit/resources/strings.dart';

class KTDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T item) titleBuilder;
  final String Function(T item, bool isSelected)? selectedItemBuilder;
  final void Function(T selectedItem) onSelected;
  final T? selectedItem;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final BoxDecoration? backgroundDecoration;
  final Widget? trailingWidget;
  final String? hintText;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final Function(Size)? onSizeCalculated;

  const KTDropdown(
      {super.key,
      required this.items,
      required this.titleBuilder,
      this.selectedItemBuilder,
      required this.onSelected,
      this.selectedItem,
      this.padding,
      this.borderRadius,
      this.backgroundDecoration,
      this.trailingWidget,
      this.hintText,
      this.textStyle,
      this.hintTextStyle,
      this.onSizeCalculated});

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
    return ChildSizeNotifier(
      builder: (_, size, __) {
        if (size.height > 0 && widget.onSizeCalculated != null) {
          widget.onSizeCalculated!(size);
        }

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
            hint: DropdownMenuItem(
              value: widget.hintText ?? AppStrings.select.tr(),
              child: Text(
                widget.hintText ?? AppStrings.select.tr(),
                style: widget.hintTextStyle,
              ),
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
            selectedItemBuilder: widget.selectedItemBuilder != null
                ? (context) => List.generate(
                      widget.items.length,
                      (position) {
                        final currentData = widget.items[position];
                        return DropdownMenuItem(
                          value: currentData,
                          child: Text(
                            widget.selectedItemBuilder!(currentData, selectedItemIndex == position),
                            style: widget.textStyle,
                          ),
                        );
                      },
                    )
                : null,
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
      },
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
