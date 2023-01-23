import 'brand.dart';

class MenuBrands {
  final List<MenuBrand> results;
  final int total;
  final int page;
  final int size;

  MenuBrands(
      {required this.results,
      required this.total,
      required this.page,
      required this.size});
}
