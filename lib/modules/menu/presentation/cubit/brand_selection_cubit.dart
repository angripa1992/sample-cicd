import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/menu/domain/entities/brand.dart';

class BrandSelectionCubit extends Cubit<MenuBrand?>{
  BrandSelectionCubit() : super(null);

  void changeBrand(MenuBrand brand){
    emit(brand);
  }
}