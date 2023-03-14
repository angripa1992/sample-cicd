import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../app/constants.dart';
import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../core/provider/image_url_provider.dart';
import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/items.dart';
import '../../../domain/entities/stock.dart';
import 'menu_snooze_view.dart';
import 'menu_switch_view.dart';

class MenuItemDetails extends StatefulWidget {
  final MenuItems items;
  final bool parentEnabled;
  final Function(Stock) onChanged;
  final int brandID;
  final int providerID;
  final int brandId;

  const MenuItemDetails({
    Key? key,
    required this.items,
    required this.parentEnabled,
    required this.onChanged,
    required this.brandID,
    required this.providerID,
    required this.brandId,
  }) : super(key: key);

  @override
  State<MenuItemDetails> createState() => _MenuItemDetailsState();
}

class _MenuItemDetailsState extends State<MenuItemDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: ImageUrlProvider.getUrl(widget.items.image),
                imageBuilder: (context, imageProvider) => Container(
                  height: AppSize.s180.rh,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSize.s14.rSp),
                    ),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSize.s24.rh),
                    child:
                        CircularProgressIndicator(strokeWidth: AppSize.s2.rSp),
                  ),
                ),
                errorWidget: (context, url, error) => Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSize.s24.rh),
                  child: Center(
                    child: SvgPicture.asset(
                      AppImages.placeholder,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.cancel_rounded,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: AppSize.s8.rh,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s10.rw),
                    child: Text(
                      widget.items.title,
                      style: getRegularTextStyle(
                        fontSize: AppFontSize.s16.rSp,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
                MenuSnoozeView(
                  items: widget.items,
                  brandId: widget.brandId,
                  providerId: widget.providerID,
                  borderRadius: AppSize.s16.rSp,
                  width: AppSize.s100.rw,
                  bgColor: AppColors.dustyOrange.withOpacity(0.1),
                  parentEnabled: widget.parentEnabled,
                  iconPath: AppIcons.edit,
                  // onEnabledChange: (enabled) {
                  //   widget.onChanged(enabled);
                  //   setState(() {
                  //     widget.items.stock.available = enabled;
                  //   });
                  //   //Navigator.pop(context);
                  // },
                  onChanged: (stock) {
                    widget.onChanged(stock);
                    setState(() {
                      widget.items.stock = stock;
                    });
                  },
                ),
                MenuSwitchView(
                  id: widget.items.id,
                  brandId: widget.brandID,
                  providerId: widget.providerID,
                  type: MenuType.ITEM,
                  enabled: widget.items.stock.available,
                  parentEnabled: widget.parentEnabled,
                  // on: (enabled) {
                  //   widget.onChanged(enabled);
                  //   setState(() {
                  //     widget.items.stock.available = enabled;
                  //   });
                  // },
                  willShowBg: false,
                  onItemChanged: (stock) {
                    widget.onChanged(stock);
                    setState(() {
                      widget.items.stock = stock;
                    });
                  },
                  onMenuChanged: (enabled) {},
                ),
              ],
            ),
          ),
          if (widget.items.stock.snooze.endTime.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                bottom: AppSize.s8.rh,
                right: AppSize.s10.rw,
                left: AppSize.s10.rw,
              ),
              child: Text(
                '(OOS till ${DateTimeProvider.parseSnoozeEndTime(widget.items.stock.snooze.endTime)})',
                textAlign: TextAlign.right,
                style: getMediumTextStyle(
                  color: AppColors.warmRed,
                  fontSize: AppFontSize.s12.rSp,
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s10.rw),
                child: Text(
                  widget.items.description,
                  textAlign: TextAlign.start,
                  style: getRegularTextStyle(
                      fontSize: AppFontSize.s14.rSp, color: AppColors.coolGrey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
