import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/common/entities/brand.dart';

class BrandSelectionCubit extends Cubit<Brand?> {
  BrandSelectionCubit() : super(null);

  void changeBrand(Brand brand) {
    emit(brand);
  }
}
