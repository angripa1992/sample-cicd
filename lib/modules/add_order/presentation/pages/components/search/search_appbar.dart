import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class SearchAppBar extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) onTextChanged;

  const SearchAppBar(
      {Key? key, required this.onBack, required this.onTextChanged})
      : super(key: key);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {

  Timer? _debounce;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 3), () {
      if(value.isEmpty || value.length > 2){
        widget.onTextChanged(value.toLowerCase());
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
        child: Row(
          children: [
            IconButton(
              onPressed: widget.onBack,
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.purpleBlue,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: AppSize.s8.rh,
                  bottom: AppSize.s8.rh,
                  right: AppSize.s16.rw,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                  color: AppColors.seaShell,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s10.rw),
                  child: TextField(
                    autofocus:true,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search for items and categories',
                      hintStyle: getRegularTextStyle(
                        color: AppColors.dustyGreay,
                        fontSize: AppFontSize.s12.rSp,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
