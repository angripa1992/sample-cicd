import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/usecases/delete_comment.dart';

import '../../../../../core/utils/response_state.dart';
import '../../../domain/usecases/add_comment.dart';

class CommentCubit extends Cubit<ResponseState> {
  final AddComment _addCommentUseCase;
  final DeleteComment _deleteCommentUseCase;

  CommentCubit(this._addCommentUseCase, this._deleteCommentUseCase)
      : super(Empty());

  void addComment(AddCommentParams params) async {
    emit(Loading());
    final response = await _addCommentUseCase(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (success) {
        emit(Success<ActionSuccess>(success));
      },
    );
  }

  void deleteComment(int orderID) async {
    emit(Loading());
    final response = await _deleteCommentUseCase(orderID);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (success) {
        emit(Success<ActionSuccess>(success));
      },
    );
  }
}
