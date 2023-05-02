import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/tag_title.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/order_source.dart';

class SourceSelector extends StatefulWidget {
  final AddOrderSourceType? sourceType;
  final AddOrderSource? source;
  final List<AddOrderSourceType> sources;
  final Function(AddOrderSourceType, AddOrderSource) onChangeSource;

  const SourceSelector({
    Key? key,
    required this.sources,
    this.sourceType,
    this.source,
    required this.onChangeSource,
  }) : super(key: key);

  @override
  State<SourceSelector> createState() => _SourceSelectorState();
}

class _SourceSelectorState extends State<SourceSelector> {
  late AddOrderSourceType _currentSourceType;
  late AddOrderSource _currentSource;

  @override
  void initState() {
    if (widget.source == null) {
      _currentSourceType =
          widget.sources.firstWhere((element) => element.id == 4);
      _currentSource =
          _currentSourceType.sources.firstWhere((element) => element.id == 9);
      widget.onChangeSource(_currentSourceType, _currentSource);
    } else {
      _currentSourceType = widget.sourceType!;
      _currentSource = widget.source!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (dContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSize.s16.rSp),
                ),
              ),
              content: SourceSelectorDropdown(
                sources: widget.sources,
                source: _currentSource,
                sourceType: _currentSourceType,
                onChangeSource: (sourceType, source) {
                  setState(() {
                    _currentSource = source;
                  });
                  widget.onChangeSource(sourceType, source);
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppSize.s8.rh,
          horizontal: AppSize.s16.rw,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s8.rw,
          vertical: AppSize.s8.rh,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
          color: AppColors.white,
        ),
        child: Column(
          children: [
            const TagTitleView(title: 'Order Source',required: true),
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.s10.rw,
                vertical: AppSize.s8.rh,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                color: AppColors.whiteSmoke,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currentSource.name,
                    style: getRegularTextStyle(
                      color: AppColors.balticSea,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SourceSelectorDropdown extends StatefulWidget {
  final AddOrderSourceType sourceType;
  final AddOrderSource source;
  final List<AddOrderSourceType> sources;
  final Function(AddOrderSourceType, AddOrderSource) onChangeSource;

  const SourceSelectorDropdown({
    Key? key,
    required this.sources,
    required this.sourceType,
    required this.source,
    required this.onChangeSource,
  }) : super(key: key);

  @override
  State<SourceSelectorDropdown> createState() => _SourceSelectorDropdownState();
}

class _SourceSelectorDropdownState extends State<SourceSelectorDropdown> {
  AddOrderSourceType? _currentSourceType;
  AddOrderSource? _currentSource;

  @override
  void initState() {
    _currentSourceType = widget.sourceType;
    _currentSource = widget.source;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.sources.map((sourceType) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s8.rw,
                  vertical: AppSize.s4.rh,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s4.rSp),
                  color: AppColors.pearl,
                ),
                child: Text(
                  sourceType.name,
                  style: getMediumTextStyle(
                    color: AppColors.balticSea,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s8.rw,
                  vertical: AppSize.s8.rh,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: sourceType.sources.map((source) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _currentSourceType = sourceType;
                          _currentSource = source;
                        });
                        widget.onChangeSource(
                            _currentSourceType!, _currentSource!);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSize.s8.rh,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              source.name,
                              style: getRegularTextStyle(
                                color: AppColors.balticSea,
                                fontSize: AppFontSize.s14.rSp,
                              ),
                            ),
                            if (_currentSource!.id == source.id)
                              Icon(Icons.check, color: AppColors.purpleBlue),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          );
        }).toList(),
      ),
    );
  }
}
