import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/data/models/attachment_image_file.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/resources/assets.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class AttachmentView extends StatefulWidget {
  final Order order;

  const AttachmentView({super.key, required this.order});

  @override
  State<AttachmentView> createState() => _AttachmentViewState();
}

class _AttachmentViewState extends State<AttachmentView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Attachment',
          style: semiBoldTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        FutureBuilder<List<AttachmentImageFile>>(
          future: getIt.get<OrderRepository>().fetchAttachments(widget.order.id),
          builder: (_, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return SizedBox(
                height: AppSize.s110.rh,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.map((image) {
                    return _listItem(snapshot.data!.indexOf(image), image);
                  }).toList(),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _listItem(int index, AttachmentImageFile file) {
    return Padding(
      padding: EdgeInsets.only(right: AppSize.s16.rw),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
            child: Text(
              'Customer ${index + 1}',
              style: mediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          ),
          Row(
            children: [
              _imageItem('Customer ${index + 1}', 'Front', file.front ?? ''),
              SizedBox(width: AppSize.s8.rw),
              _imageItem('Customer ${index + 1}', 'Back', file.back ?? ''),
              SizedBox(width: AppSize.s8.rw),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageItem(String customerNumber, String imageSide, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          imageSide,
          style: regularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        SizedBox(height: AppSize.s4.rh),
        InkWell(
          onTap: () {
            _showImagePreview(imageUrl, customerNumber, imageSide);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            child: Image.network(
              imageUrl,
              height: AppSize.s50.rh,
              width: AppSize.s100.rw,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSize.s16.rSp),
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) {
                return Icon(Icons.error_outline, color: AppColors.red);
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePreview(String imageUrl, String customerNumber, String imageSide) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.s16.rSp),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
                  child: Text(
                    'Image Preview',
                    style: boldTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s16.rSp,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.clear),
                )
              ],
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.s16.rw,
                vertical: AppSize.s8.rh,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s12.rSp),
                child: Image.network(
                  imageUrl,
                  height: AppSize.s200.rh,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSize.s16.rSp),
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) {
                    return Icon(Icons.error_outline, color: AppColors.red);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.s16.rw,
                vertical: AppSize.s8.rh,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.seniorCitizen,
                    width: AppSize.s18.rw,
                    height: AppSize.s18.rh,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
                    child: Text(
                      customerNumber,
                      style: mediumTextStyle(
                        color: AppColors.black,
                        fontSize: AppSize.s16.rSp,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw, vertical: AppSize.s2.rh),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyDark),
                      borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                    ),
                    child: Text(
                      imageSide,
                      style: regularTextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.s12.rSp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
