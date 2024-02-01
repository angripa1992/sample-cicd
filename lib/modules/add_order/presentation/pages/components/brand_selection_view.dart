import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';

class BrandSelectionView extends StatelessWidget {
  final Function(Brand) onBrandSelected;

  const BrandSelectionView({super.key, required this.onBrandSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 8.rh),
        child: FutureBuilder<List<Brand>>(
          future: getIt.get<BusinessInformationProvider>().fetchBrands(),
          builder: (_, snap) {
            if (snap.hasData && snap.data != null) {
              return GridView.count(
                primary: false,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: snap.data!.map((brand) => _brandItem(context, brand)).toList(),
              );
            }
            return const CircularProgress();
          },
        ),
      ),
    );
  }

  Widget _brandItem(BuildContext context, Brand brand) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onBrandSelected(brand);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.neutralB40,
          ),
          borderRadius: BorderRadius.circular(8.rSp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KTNetworkImage(
              imageUrl: brand.logo,
              width: 42.rSp,
              height: 42.rSp,
            ),
            SizedBox(height: 8.rh),
            Text(
              brand.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: mediumTextStyle(
                color: AppColors.neutralB300,
                fontSize: 14.rSp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
