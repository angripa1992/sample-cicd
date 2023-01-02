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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s4.rSp),
        color: _currentOrder!.klikitComment.isEmpty
            ? AppColors.lightVioletTwo
            : AppColors.purpleBlue,
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s8.rw,
            vertical: AppSize.s4.rh,
          ),
          child: Row(
            children: [
              Icon(
                _currentOrder!.klikitComment.isEmpty
                    ? Icons.add_comment_outlined
                    : Icons.comment_outlined,
                size: AppSize.s18.rSp,
                color: _currentOrder!.klikitComment.isEmpty
                    ? AppColors.purpleBlue
                    : AppColors.white,
              ),
              SizedBox(width: AppSize.s8.rw),
              Text(
                _currentOrder!.klikitComment.isEmpty
                    ? AppStrings.add_comment.tr()
                    : AppStrings.see_comment.tr(),
                style: getRegularTextStyle(
                  color: _currentOrder!.klikitComment.isEmpty
                      ? AppColors.purpleBlue
                      : AppColors.white,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
