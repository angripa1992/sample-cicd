import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_list_item.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/sections.dart';
import 'menu_switch_view.dart';

class MenuListView extends StatefulWidget {
  final List<Sections> sections;

  const MenuListView({Key? key, required this.sections}) : super(key: key);

  @override
  State<MenuListView> createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  late List<ExpandedTileController> tileControllers;

  @override
  void initState() {
    tileControllers = List.generate(
      widget.sections.length,
      (index) => ExpandedTileController(key: index),
    );
    super.initState();
  }

  void changeController(int index, bool isExpanded) {
    for (int i = 0; i < tileControllers.length; i++) {
      if (!isExpanded) {
        if (index == i) {
          tileControllers[i] = tileControllers[i].copyWith(isExpanded: true);
        } else {
          tileControllers[i] = tileControllers[i].copyWith(isExpanded: false);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ExpandedTileList.seperated(
        itemCount: widget.sections.length,
        itemBuilder: (context,index,controller){
          controller.addListener(() {
            setState(() {

            });
          });
          return ExpandedTile(
            theme: ExpandedTileThemeData(
              headerColor: Colors.green,
              headerRadius: AppSize.s8.rSp,
              // headerPadding: EdgeInsets.symmetric(
              //   horizontal: AppSize.s12.rw,
              //   vertical: controller.isExpanded ? AppSize.s16.rh : AppSize.ZERO,
              // ),
              titlePadding: EdgeInsets.zero,
              trailingPadding: EdgeInsets.zero,
              leadingPadding: EdgeInsets.zero,
              headerPadding: EdgeInsets.symmetric(horizontal: 0),
              headerSplashColor: controller.isExpanded ? AppColors.lightViolet : AppColors.white,
              contentBackgroundColor: Colors.white,
              contentPadding: EdgeInsets.all(4.0),
              contentRadius: 12.0,
            ),
            trailingRotation: -90,
            controller: controller,
            trailing: SizedBox(),

            title: Card(
              color : controller.isExpanded ? AppColors.purpleBlue : AppColors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${index + 1}.   ${widget.sections[index].title}',
                      style: getRegularTextStyle(
                        color: controller.isExpanded
                            ? AppColors.white
                            : AppColors.purpleBlue,
                        fontSize: AppFontSize.s15.rSp,
                      ),
                    ),
                   controller.isExpanded
                        ? Text(
                      '${widget.sections[index].subSections.length} items',
                      style: getRegularTextStyle(
                        color: AppColors.white,
                        fontSize: AppFontSize.s15.rSp,
                      ),
                    )
                        : MenuSwitchView(),
                  ],
                ),
              ),
            ),
            content: Text('wjfbhwkjf'),
          );
        },
        seperatorBuilder: (context,_){
          return SizedBox(height: 20,);
        },
      ),
      // child: ListView.builder(
      //   itemCount: widget.sections.length,
      //   itemBuilder: (context, index) {
      //     debugPrint('${widget.sections[index].isExpanded}');
      //     return MenuListItem(
      //       sections: widget.sections[index],
      //       index: index,
      //       onExpandedCallback: (isExpanded) {
      //         changeController(index, isExpanded);
      //       }, controller: tileControllers[index],
      //     );
      //   },
      // ),
    );
  }
}
