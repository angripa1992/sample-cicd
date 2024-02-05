import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/base/kt_app_bar.dart';
import 'package:klikit/modules/widgets/negative_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/styles.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CimbQrPaymentScreen extends StatelessWidget {
  const CimbQrPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KTAppBar(
        title: 'Scan QR Code',
        onNavBack: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 24.rh),
              padding: EdgeInsets.all(16.rSp),
              decoration: regularRoundedDecoration(radius: 8.rSp, backgroundColor: AppColors.white),
              child: Column(
                children: [
                  Text('MERCHANT NAME', style: mediumTextStyle(fontSize: 16.rSp, color: AppColors.neutralB600)),
                  Text('NMID: IDXXXXXXXXXXX', style: regularTextStyle(fontSize: 14.rSp, color: AppColors.neutralB600)),
                  16.verticalSpacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.rw, vertical: 20.rh),
                    decoration: regularRoundedDecoration(radius: 12.rSp, backgroundColor: AppColors.neutralB20),
                    child: QrImageView(
                      data:
                          '00020101021226710019ID.CO.CIMBNIAGA.WWW011893600022000000952402150000081000178540303UME51450015ID.OR.QRNPG.WWW0215IDKIT36563555550303UME520460105303360540813101.005802ID5906KLIKIT6007JAKARTA610511730622205062591520708898601006304FB5F',
                      version: QrVersions.auto,
                      size: 203.rSp,
                    ),
                  ),
                  16.verticalSpacer(),
                  Text('NNS Code: 1234567890', style: regularTextStyle(fontSize: 14.rSp, color: AppColors.neutralB600)),
                  16.verticalSpacer(),
                  Text('Payment QR code', style: boldTextStyle(fontSize: 20.rSp, color: AppColors.neutralB700)),
                  8.verticalSpacer(),
                  Text('Scan the qr code to proceed with the QRIS Payment', style: regularTextStyle(fontSize: 14.rSp, color: AppColors.neutralB200)),
                ],
              ),
            ),
            Container(
              color: AppColors.white,
              padding: EdgeInsets.all(16.rSp),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text('Total'),
                      Spacer(),
                      Text('PHP 650.00'),
                    ],
                  ),
                  10.verticalSpacer(),
                  NegativeButton(
                    negativeText: 'Pay Now',
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
