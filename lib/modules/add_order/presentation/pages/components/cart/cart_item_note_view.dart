import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../note_text_field.dart';

class CartItemNoteView extends StatefulWidget {
  final AddToCartItem cartItem;

  const CartItemNoteView({Key? key, required this.cartItem}) : super(key: key);

  @override
  State<CartItemNoteView> createState() => _CartItemNoteViewState();
}

class _CartItemNoteViewState extends State<CartItemNoteView> {
  final _controller = TextEditingController();
  late String _instruction;

  @override
  void initState() {
    _instruction = widget.cartItem.itemInstruction;
    _controller.text = _instruction;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      _instruction = _controller.text.toString();
    });
    widget.cartItem.itemInstruction = _instruction;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _instruction.isEmpty
        ? const SizedBox()
        : InkWell(
            onTap: () {
              _openNote();
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.rh),
              padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 8.rh),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.rSp),
                border: Border.all(color: AppColors.neutralB40),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.note_rounded,
                    size: 18.rSp,
                    color: AppColors.neutralB200,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.rw),
                      child: Text(
                        widget.cartItem.itemInstruction,
                        overflow: TextOverflow.ellipsis,
                        style: mediumTextStyle(
                          color: AppColors.neutralB200,
                          fontSize: 13.rSp,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.edit,
                    size: 18.rSp,
                    color: AppColors.neutralB200,
                  ),
                ],
              ),
            ),
          );
  }

  void _openNote() {
    showDialog(
      context: context,
      builder: (dContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.rSp),
            ),
          ),
          //contentPadding: EdgeInsets.zero,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.note_rounded, color: AppColors.neutralB100,size: 20.rSp),
                  SizedBox(width: 8.rw),
                  Expanded(
                    child: Text(
                      AppStrings.note.tr(),
                      style: boldTextStyle(
                        color: AppColors.neutralB600,
                        fontSize: 16.rSp,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.rh),
                child: NoteTextField(
                  controller: _controller,
                  hint: AppStrings.add_instruction.tr(),
                  minLines: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _save,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.rh),
                        child: Text(
                          AppStrings.dismiss.tr(),
                          style: mediumTextStyle(
                            color: AppColors.black,
                            fontSize: 14.rSp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.rw),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.rh),
                        child: Text(
                          AppStrings.save.tr(),
                          style: mediumTextStyle(
                            color: AppColors.white,
                            fontSize: 14.rSp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
