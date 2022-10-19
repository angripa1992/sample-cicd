import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/usecases/delete_comment.dart';

import '../../../../../core/utils/response_state.dart';

class DeleteCommentCubit extends Cubit<ResponseState> {
  final DeleteComment _deleteCommentUseCase;

  DeleteCommentCubit(this._deleteCommentUseCase) : super(Empty());

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
