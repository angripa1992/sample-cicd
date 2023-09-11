import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../dialogs/comment_dialog.dart';

class CommentActionView extends StatefulWidget {
  const CommentActionView(
      {Key? key, required this.onCommentActionSuccess, required this.order})
      : super(key: key);

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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s8.rw,
        vertical: AppSize.s6.rh,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        border: Border.all(color: AppColors.black),
      ),
      child: InkWell(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _currentOrder!.klikitComment.isEmpty
                  ? Icons.add_comment_outlined
                  : Icons.chat,
              size: AppSize.s16.rSp,
              color: AppColors.black,
            ),
            SizedBox(width: AppSize.s8.rw),
            Flexible(
              child: Text(
                _currentOrder!.klikitComment.isEmpty
                    ? AppStrings.add_comment.tr()
                    : AppStrings.see_comment.tr(),
                style: regularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
