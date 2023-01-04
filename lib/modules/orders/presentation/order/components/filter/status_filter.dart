import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/order/components/filter/status_filter_item.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../observer/filter_subject.dart';

class StatusFilter extends StatefulWidget {
  final FilterSubject subject;
  final TabController tabController;

  const StatusFilter(
      {Key? key, required this.subject, required this.tabController})
      : super(key: key);

  @override
  State<StatusFilter> createState() => _StatusFilterState();
}

class _StatusFilterState extends State<StatusFilter> {
  final _controller = ExpandedTileController(isExpanded: false, key: 1);
  late int _currentTabIndex;
  final List<StatusItem> _statusItems = [
    StatusItem(OrderStatus.DELIVERED, AppStrings.delivered.tr()),
    StatusItem(OrderStatus.CANCELLED, AppStrings.canceled.tr()),
  ];

  @override
  void initState() {
    _currentTabIndex = widget.tabController.index;
    widget.tabController.addListener(_tabListener);
    widget.subject.setStatus([OrderStatus.DELIVERED, OrderStatus.CANCELLED]);
    super.initState();
  }

  void _tabListener() {
    final previous = widget.tabController.previousIndex;
    final current = widget.tabController.index;
    if (previous == OrderTab.History || current == OrderTab.History) {
      setState(() {
        _currentTabIndex = widget.tabController.index;
      });
    }
  }

  void _changeSelectedStatus(bool isChecked, StatusItem item) async {
    final statusItem = item.copyWith(isChecked: isChecked);
    _statusItems[_statusItems
        .indexWhere((element) => element.id == statusItem.id)] = statusItem;
    widget.subject.applyStatusFilter(
      _statusItems
          .where((element) => element.isChecked)
          .toList()
          .map((e) => e.id)
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _currentTabIndex == OrderTab.History,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s14.rw, vertical: AppSize.s12.rh),
            child: Text(
              AppStrings.filter_by_aggregator.tr(),
              style: getRegularTextStyle(
                color: AppColors.purpleBlue,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
            child: ExpandedTile(
              theme: ExpandedTileThemeData(
                headerColor: AppColors.lightVioletTwo,
                headerPadding: EdgeInsets.symmetric(
                  horizontal: AppSize.s8.rw,
                  vertical: AppSize.s8.rh,
                ),
                headerSplashColor: AppColors.lightViolet,
                contentBackgroundColor: AppColors.pearl,
                contentPadding: EdgeInsets.zero,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.black,
              ),
              trailingRotation: 180,
              title: Text(
                AppStrings.status.tr(),
                style: getRegularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
              content: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  itemCount: _statusItems.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return StatusFilterItem(
                      statusItem: _statusItems[index],
                      onCheckedChanged: _changeSelectedStatus,
                    );
                  },
                ),
              ),
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusItem {
  final int id;
  final String name;
  final bool isChecked;

  StatusItem(this.id, this.name, {this.isChecked = true});

  StatusItem copyWith({required isChecked}) {
    return StatusItem(id, name, isChecked: isChecked);
  }
}
