import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/base/kt_app_bar.dart';
import 'package:klikit/modules/widgets/negative_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CimbQrPaymentScreen extends StatefulWidget {
  const CimbQrPaymentScreen({super.key});

  @override
  State<CimbQrPaymentScreen> createState() => _CimbQrPaymentScreenState();
}

class _CimbQrPaymentScreenState extends State<CimbQrPaymentScreen> {
  final _dynamicSize = ValueNotifier<Size?>(null);

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
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: ScreenSizes.screenWidth,
                  margin: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 12.rh),
                  decoration: regularRoundedDecoration(radius: 12.rSp),
                  clipBehavior: Clip.hardEdge,
                  child: MeasureSize(
                    onChange: (size) {
                      debugPrint('Height of the bg ${size.height}');
                      if (size.height > 300) {
                        _dynamicSize.value = size;
                      }
                    },
                    child: ImageResourceResolver.cimbPaymentBgSVG.getImageWidget(
                      width: ScreenSizes.screenWidth,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ),
                ValueListenableBuilder<Size?>(
                  valueListenable: _dynamicSize,
                  builder: (_, calculatedSize, __) {
                    if ((calculatedSize?.height ?? 0) > 0) {
                      return QrContent(height: calculatedSize!.height);
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.rw),
              padding: EdgeInsets.all(8.rSp),
              decoration: regularRoundedDecoration(strokeColor: AppColors.warningY300, backgroundColor: AppColors.warningY50, radius: 8.rSp),
              child: Row(
                children: [
                  ImageResourceResolver.timeSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.warningY300),
                  8.horizontalSpacer(),
                  Expanded(
                    child: Text(
                      'Complete the payment within 01 February 04:00PM',
                      style: mediumTextStyle(color: AppColors.neutralB600, fontSize: 14.rSp),
                    ),
                  ),
                  8.horizontalSpacer(),
                  Text(
                    '48m 43s',
                    style: mediumTextStyle(color: AppColors.neutralB600, fontSize: 18.rSp),
                  ),
                ],
              ),
            ),
            Container(
              color: AppColors.white,
              padding: EdgeInsets.all(16.rSp),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Total', style: regularTextStyle(fontSize: 14.rSp, color: AppColors.neutralB700)),
                      Text('(including VAT)', style: regularTextStyle(fontSize: 10.rSp, color: AppColors.neutralB500)),
                      const Spacer(),
                      Text('PHP 650.00', style: regularTextStyle(fontSize: 14.rSp, color: AppColors.neutralB700)),
                    ],
                  ),
                  10.verticalSpacer(),
                  NegativeButton(
                    negativeText: 'Continue',
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

class QrContent extends StatelessWidget {
  final double? height;

  const QrContent({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          16.verticalSpacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.rw),
            child: Row(
              children: [ImageResourceResolver.qrisSloganSVG.getImageWidget(), const Spacer(), ImageResourceResolver.gpnLogoSVG.getImageWidget()],
            ),
          ),
          12.verticalSpacer(),
          Text('KLIKAT', style: mediumTextStyle(fontSize: 16.rSp, color: AppColors.neutralB600)),
          Text('NMID: IDKIT3656355555', style: regularTextStyle(fontSize: 14.rSp, color: AppColors.neutralB600)),
          16.verticalSpacer(),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.rw),
            child: QrImageView(
              backgroundColor: AppColors.white,
              padding: EdgeInsets.all(16.rSp),
              data:
                  '00020101021226710019ID.CO.CIMBNIAGA.WWW011893600022000000952402150000081000178540303UME51450015ID.OR.QRNPG.WWW0215IDKIT36563555550303UME520460105303360540813101.005802ID5906KLIKIT6007JAKARTA610511730622205062591520708898601006304FB5F',
              version: QrVersions.auto,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 36.rw),
            child: Row(children: [Text('Dicetak oleh: 93600022', style: regularTextStyle(fontSize: 14.rSp, color: AppColors.neutralB600), textAlign: TextAlign.start), const Spacer()]),
          ),
          16.verticalSpacer(),
        ],
      ),
    );
  }
}

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();
    if (child != null) {
      Size newSize = child!.size;
      if (oldSize == newSize) return;

      oldSize = newSize;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        onChange(newSize);
      });
    }
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}
