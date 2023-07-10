import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/usecases/add_comment.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../../../resources/colors.dart';
import '../../../../../../../resources/fonts.dart';
import '../../../../../../../resources/styles.dart';
import '../../../../../../../resources/values.dart';
import '../../../../../../core/utils/response_state.dart';
import '../../../../widgets/loading_button.dart';
import '../../../domain/entities/order.dart';
import '../../bloc/add_comment_cubit.dart';
import '../../bloc/delete_comment_cubit.dart';

void showCommentDialog({
  required BuildContext context,
  required Order order,
  required VoidCallback onCommentActionSuccess,
  required Function(String) changeCommentAction,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt.get<AddCommentCubit>()),
          BlocProvider(create: (_) => getIt.get<DeleteCommentCubit>()),
        ],
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.s16.rSp),
            ),
          ),
          content: CommentDialogBody(
            order: order,
            onCommentActionSuccess: onCommentActionSuccess,
            changeCommentAction: changeCommentAction,
          ),
        ),
      );
    },
  );
}

class CommentDialogBody extends StatefulWidget {
  final Order order;
  final VoidCallback onCommentActionSuccess;
  final Function(String) changeCommentAction;

  const CommentDialogBody({
    Key? key,
    required this.order,
    required this.onCommentActionSuccess,
    required this.changeCommentAction,
  }) : super(key: key);

  @override
  State<CommentDialogBody> createState() => _CommentDialogBodyState();
}

class _CommentDialogBodyState extends State<CommentDialogBody> {
  late TextEditingController _controller;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _controller = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _controller.text = widget.order.klikitComment;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final params = {'comment': _controller.text.toString()};
      context.read<AddCommentCubit>().addComment(
            AddCommentParams(params, widget.order.id),
          );
    }
  }

  void _delete(BuildContext context) {
    context.read<DeleteCommentCubit>().deleteComment(widget.order.id);
  }

  void _pop() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.order.klikitComment.isEmpty
              ? AppStrings.add_comment.tr()
              : AppStrings.edit_comment.tr(),
          style: mediumTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.s16.rh),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              style: regularTextStyle(
                color: AppColors.blackCow,
                fontSize: AppFontSize.s14.rSp,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.order_comment.tr(),
                hintStyle: regularTextStyle(
                  color: AppColors.blackCow,
                  fontSize: AppFontSize.s14.rSp,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.blueViolet),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.blueViolet),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.blackCow),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.comment_validation_msg.tr();
                }
                return null;
              },
            ),
          ),
        ),
        Row(
          children: [
            Visibility(
              visible: widget.order.klikitComment.isNotEmpty,
              child: Expanded(
                child: BlocConsumer<DeleteCommentCubit, ResponseState>(
                  listener: (context, state) {
                    if (state is Success<ActionSuccess>) {
                      widget.changeCommentAction('');
                      widget.onCommentActionSuccess();
                      _pop();
                      showSuccessSnackBar(context,
                          AppStrings.comment_deleted_successfully.tr());
                    } else if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    }
                  },
                  builder: (context, state) {
                    return LoadingButton(
                      isLoading: (state is Loading),
                      verticalPadding: AppSize.s8.rh,
                      text: AppStrings.delete.tr(),
                      borderColor: AppColors.black,
                      bgColor: AppColors.black,
                      textColor: AppColors.white,
                      textSize: AppFontSize.s12.rSp,
                      onTap: () {
                        _delete(context);
                      },
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: widget.order.klikitComment.isNotEmpty,
              child: SizedBox(width: AppSize.s8.rw),
            ),
            Expanded(
              child: BlocConsumer<AddCommentCubit, ResponseState>(
                listener: (context, state) {
                  if (state is Success<ActionSuccess>) {
                    widget.changeCommentAction(_controller.text);
                    widget.onCommentActionSuccess();
                    _pop();
                    showSuccessSnackBar(
                      context,
                      widget.order.klikitComment.isEmpty
                          ? AppStrings.comment_added_successfully.tr()
                          : AppStrings.comment_updated_successfully.tr(),
                    );
                  } else if (state is Failed) {
                    showApiErrorSnackBar(context, state.failure);
                  }
                },
                builder: (context, state) {
                  return LoadingButton(
                    isLoading: (state is Loading),
                    verticalPadding: AppSize.s8.rh,
                    onTap: () {
                      _validate(context);
                    },
                    text: widget.order.klikitComment.isEmpty
                        ? AppStrings.add.tr()
                        : AppStrings.save.tr(),
                    textSize: AppFontSize.s12.rSp,
                  );
                },
              ),
            ),
            SizedBox(width: AppSize.s8.rw),
            Expanded(
              child: LoadingButton(
                isLoading: false,
                verticalPadding: AppSize.s8.rh,
                text: AppStrings.cancel.tr(),
                borderColor: AppColors.black,
                bgColor: AppColors.white,
                textColor: AppColors.black,
                textSize: AppFontSize.s12.rSp,
                onTap: _pop,
              ),
            ),
          ],
        )
      ],
    );
  }
}
