import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
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
        : Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
            child: InkWell(
              onTap: () {
                _openNote();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s8.rw,
                  vertical: AppSize.s8.rh,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                  border: Border.all(color: AppColors.greyDarker),
                  color: AppColors.grey,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.cartItem.itemInstruction,
                        overflow: TextOverflow.ellipsis,
                        style: regularTextStyle(
                          color: AppColors.greyDarker,
                          fontSize: AppFontSize.s12.rSp,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.edit_outlined,
                      size: AppSize.s18.rSp,
                      color: AppColors.greyDarker,
                    ),
                  ],
                ),
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
              Radius.circular(AppSize.s16.rSp),
            ),
          ),
          //contentPadding: EdgeInsets.zero,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.note.tr(),
                      style: boldTextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.s16.rSp,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
              SizedBox(height: AppSize.s12.rh),
              Text(
                AppStrings.add_note_for_item.tr(),
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s12.rh),
                child: NoteTextField(
                  controller: _controller,
                  hint: AppStrings.add_instruction.tr(),
                  minLines: 2,
                ),
              ),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSize.s10.rh),
                  child: Text(
                    AppStrings.save.tr(),
                    style: mediumTextStyle(
                      color: AppColors.white,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
