import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/home/presentation/home_screen.dart';
import 'package:klikit/modules/orders/presentation/pages/orders_screen.dart';
import 'package:klikit/modules/stock/presentation/pages/stock_screen.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../resources/colors.dart';
import '../../resources/strings.dart';
import '../user/presentation/account/account_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    OrdersScreen(),
    StockScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_selectedIndex == 0) {
          return Future.value(true);
        } else {
          _onItemTapped(0);
          return Future.value(false);
        }
      },
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _navigationItems(),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: AppColors.whiteSmoke,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.purpleBlue,
          unselectedItemColor: AppColors.smokeyGrey,
          selectedLabelStyle: getRegularTextStyle(
            color: AppColors.purpleBlue,
            fontSize: 14.rSp,
            fontFamily: AppFonts.ABeeZee,
          ),
          unselectedLabelStyle: getRegularTextStyle(
            fontFamily: AppFonts.ABeeZee,
            color: AppColors.smokeyGrey,
            fontSize: 14.rSp,
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _navigationItems() {
    return [
      BottomNavigationBarItem(
        icon: _generateNavIcon(AppIcons.home),
        activeIcon: _generateNavIcon(AppIcons.homeActive),
        label: AppStrings.home.tr(),
      ),
      BottomNavigationBarItem(
        icon: _generateNavIcon(AppIcons.order),
        activeIcon: _generateNavIcon(AppIcons.orderActive),
        label: AppStrings.orders.tr(),
      ),
      BottomNavigationBarItem(
        icon: _generateNavIcon(AppIcons.stock),
        activeIcon: _generateNavIcon(AppIcons.stockActive),
        label: AppStrings.stock.tr(),
      ),
      BottomNavigationBarItem(
        icon: _generateNavIcon(AppIcons.account),
        activeIcon: _generateNavIcon(AppIcons.accountActive),
        label: AppStrings.account.tr(),
      ),
    ];
  }

  Widget _generateNavIcon(String iconPath) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.s4),
      child: SizedBox(
        height: AppSize.s20.rh,
        width: AppSize.s20.rw,
        child: SvgPicture.asset(iconPath),
      ),
    );
  }
}
