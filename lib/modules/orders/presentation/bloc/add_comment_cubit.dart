import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../../core/utils/response_state.dart';
import '../../domain/usecases/add_comment.dart';

class AddCommentCubit extends Cubit<ResponseState> {
  final AddComment _addCommentUseCase;

  AddCommentCubit(this._addCommentUseCase) : super(Empty());

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
}
