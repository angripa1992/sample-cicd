import 'package:flutter/material.dart';

class MenuSwitchView extends StatefulWidget {
  const MenuSwitchView({Key? key}) : super(key: key);

  @override
  State<MenuSwitchView> createState() => _MenuSwitchViewState();
}

class _MenuSwitchViewState extends State<MenuSwitchView> {
  @override
  Widget build(BuildContext context) {
    return Switch(value: true, onChanged: (value) {});
  }
}
