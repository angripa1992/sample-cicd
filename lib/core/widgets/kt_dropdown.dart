import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/resources/strings.dart';

class KTDropdown<T> extends StatefulWidget {
  final List<T> _dataItems;
  final String Function(T dataItem) _titleBuilder;
  final void Function(T? dataItem) _onItemSelected;

  final int _initSelectionIndex;

  final T? _initSelectedItem;
  final EdgeInsets? _padding;
  final BorderRadius? _borderRadius;
  final BoxDecoration? _backgroundDecoration;
  final DecoratedImageView? _suffixIcon;
  final String? _hintText;
  final TextStyle? _textStyle;
  final TextStyle? _hintTextStyle;
  final bool _applySelectedItemToList;

  const KTDropdown({
    Key? key,
    required List<T> dataItems,
    required String Function(T dataItem) titleBuilder,
    required void Function(T? dataItem) onItemSelected,
    int initSelectionIndex = -1,
    T? initSelectedItem,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    BoxDecoration? backgroundDecoration,
    DecoratedImageView? suffixIcon,
    String? hintText,
    TextStyle? textStyle,
    TextStyle? hintTextStyle,
    bool applySelectedItemToList = true,
  })  : _dataItems = dataItems,
        _titleBuilder = titleBuilder,
        _onItemSelected = onItemSelected,
        _initSelectionIndex = initSelectionIndex,
        _initSelectedItem = initSelectedItem,
        _padding = padding,
        _borderRadius = borderRadius,
        _backgroundDecoration = backgroundDecoration,
        _suffixIcon = suffixIcon,
        _hintText = hintText,
        _textStyle = textStyle,
        _hintTextStyle = hintTextStyle,
        _applySelectedItemToList = applySelectedItemToList,
        super(key: key);

  @override
  State<KTDropdown<T>> createState() => _KTDropdownState<T>();
}

class _KTDropdownState<T> extends State<KTDropdown<T>> {
  // data
  int? _selectedItemIndex;

  @override
  void initState() {
    super.initState();

    // refresh index in case parent requests rebuild.
    // this is extremely light - no worries.
    _selectedItemIndex = _refreshSelection();
  }

  @override
  void didUpdateWidget(covariant KTDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // refresh index in case parent requests rebuild.
    // this is extremely light - no worries.
    _selectedItemIndex = _refreshSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget._padding,
      decoration: widget._backgroundDecoration,
      child: DropdownButton<T>(
        isExpanded: true,
        menuMaxHeight: 384,
        underline: const SizedBox(
          width: 0,
          height: 0,
        ),
        icon: widget._suffixIcon,
        borderRadius: widget._borderRadius,
        alignment: Alignment.centerLeft,
        hint: Text(
          widget._hintText ?? AppStrings.select.tr(),
          style: widget._hintTextStyle,
        ),
        items: widget._dataItems.map<DropdownMenuItem<T>>(
          (currentData) {
            return DropdownMenuItem(
              value: currentData,
              child: Text(
                widget._titleBuilder(currentData),
                style: widget._textStyle,
              ),
            );
          },
        ).toList(),
        onChanged: (T? value) {
          // notify caller
          widget._onItemSelected(value);

          // update ui
          if (value != null && widget._applySelectedItemToList == true) {
            setState(() {
              _selectedItemIndex = _findItemIndex(value);
            });
          }
        },
        value: _selectedItemIndex != null ? widget._dataItems[_selectedItemIndex!] : null,
      ),
    );
  }

  int? _refreshSelection() {
    if (widget._initSelectedItem != null) {
      return _findItemIndex(widget._initSelectedItem as T);
    } else if (widget._dataItems.isNotEmpty && widget._initSelectionIndex >= 0 && widget._initSelectionIndex < widget._dataItems.length) {
      return widget._initSelectionIndex;
    } else {
      return null;
    }
  }

  int? _findItemIndex(T value) {
    int? idx;
    for (int i = 0; i < widget._dataItems.length; i++) {
      if (value == widget._dataItems[i]) {
        idx = i;
        break;
      }
    }
    return idx;
  }
}
