import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../../../../resources/colors.dart';
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
    return SizedBox(
      width: AppSize.s24.rw,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
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
        icon: Icon(
          _currentOrder!.klikitComment.isEmpty
              ? Icons.add_comment_outlined
              : Icons.comment_outlined,
          size: AppSize.s18.rSp,
          color: _currentOrder!.klikitComment.isEmpty ? AppColors.purpleBlue : AppColors.green,
        ),
      ),
    );
  }
}
