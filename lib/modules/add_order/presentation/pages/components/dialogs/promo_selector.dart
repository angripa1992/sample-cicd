import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/data/models/applied_promo.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/dialogs/promo_info_dialog.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class PromoSelectorView extends StatefulWidget {
  final AppliedPromo? initialPromo;
  final Function(AppliedPromo?, bool) onChanged;
  final List<AppliedPromo> promos;

  const PromoSelectorView({
    Key? key,
    this.initialPromo,
    required this.onChanged,
    required this.promos,
  }) : super(key: key);

  @override
  State<PromoSelectorView> createState() => _PromoSelectorViewState();
}

class _PromoSelectorViewState extends State<PromoSelectorView> {
  int? _appliedPromoId;

  @override
  void initState() {
    _appliedPromoId = widget.initialPromo?.id;
    super.initState();
  }

  void _changePromo(int? promoId, bool deleted) {
    setState(() {
      _appliedPromoId = promoId;
    });
    AppliedPromo? promo;
    if (promoId != null) {
      promo = widget.promos.firstWhere((element) => element.id == promoId);
    }
    widget.onChanged(promo, deleted);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.promos.map((promo) {
        return RadioListTile<int>(
          title: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        promo.code!,
                        style: regularTextStyle(
                          color: AppColors.bluewood,
                          fontSize: AppFontSize.s14.rSp,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showPromoInfoDialog(context, promo);
                      },
                      icon: Icon(
                        Icons.info_outline,
                        size: AppSize.s16.rSp,
                        color: AppColors.bluewood,
                      ),
                    ),
                  ],
                ),
              ),
              if (promo.id == _appliedPromoId)
                IconButton(
                  onPressed: () {
                    _changePromo(null, true);
                  },
                  icon: Icon(
                    Icons.remove_circle,
                    color: AppColors.red,
                  ),
                ),
            ],
          ),
          value: promo.id!,
          groupValue: _appliedPromoId,
          onChanged: (promoId) {
            _changePromo(promoId, false);
          },
          activeColor: AppColors.purpleBlue,
        );
      }).toList(),
    );
  }
}
