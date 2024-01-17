import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/core/widgets/filter/oni_filter_screen.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../app/constants.dart';
import '../../../../core/widgets/filter/filter_icon_view.dart';
import '../../../busy/presentation/pause_store_header_view.dart';
import '../oni_filter_manager.dart';

class OrderHeaderView extends StatefulWidget {
  final OniFilterManager oniFilterManager;
  final TabController tabController;

  const OrderHeaderView({
    Key? key,
    required this.oniFilterManager,
    required this.tabController,
  }) : super(key: key);

  @override
  State<OrderHeaderView> createState() => _OrderHeaderViewState();
}

class _OrderHeaderViewState extends State<OrderHeaderView> {
  OniFilteredData? _filteredData;

  @override
  void initState() {
    _filteredData = widget.oniFilterManager.filteredData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!UserPermissionManager().isBizOwner())
          Padding(
            padding: EdgeInsets.only(
              right: AppSize.s12.rw,
              left: AppSize.s12.rw,
              top: AppSize.s12.rh,
            ),
            child: const PauseStoreHeaderView(),
          ),
        if (!UserPermissionManager().isBizOwner()) Divider(color: AppColors.grey, thickness: 8.rh),
        Padding(
          padding: EdgeInsets.only(
            top: 8.rh,
            left: 12.rw,
            right: 12.rw,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Orders',
                style: semiBoldTextStyle(
                  fontSize: 16.rSp,
                  color: AppColors.black,
                ),
              ),
              StatefulBuilder(
                builder: (_, setState) {
                  return FilterIconView(
                    applied: _filteredData != null,
                    openFilterScreen: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OniFilterScreen(
                            initData: _filteredData,
                            isHistory: widget.tabController.index == OrderTab.History,
                            onApplyFilterCallback: (filteredData) {
                              setState(() {
                                _filteredData = filteredData;
                              });
                              widget.oniFilterManager.applyFilter(_filteredData);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Divider(color: AppColors.grey),
      ],
    );
  }
}
