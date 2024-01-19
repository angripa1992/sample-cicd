import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../dialogs/comment_dialog.dart';

class CommentActionView extends StatefulWidget {
  const CommentActionView({Key? key, required this.onCommentActionSuccess, required this.order}) : super(key: key);

  final VoidCallback onCommentActionSuccess;
  final Order order;

  @override
  State<CommentActionView> createState() => _CommentActionViewState();
}

class _CommentActionViewState extends State<CommentActionView> {
  Order? _currentOrder;

  @override
  void initState() {
    _currentOrder = widget.order;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KTButton(
      controller: KTButtonController(label: _currentOrder!.klikitComment.isEmpty ? AppStrings.add_comment.tr() : AppStrings.see_comment.tr()),
      prefixWidget: ImageResourceResolver.commentSVG.getImageWidget(width: AppSize.s14.rw, height: AppSize.s14.rh, color: AppColors.neutralB400),
      backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.greyBright),
      labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.neutralB700),
      splashColor: AppColors.greyBright,
      onTap: () {
        showCommentDialog(
          context: context,
          order: _currentOrder!,
          onCommentActionSuccess: widget.onCommentActionSuccess,
          changeCommentAction: (klikitComment) {
            setState(() {
              _currentOrder!.klikitComment = klikitComment;
            });
          },
        );
      },
    );
  }
}
