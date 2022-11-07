import 'package:equatable/equatable.dart';

class MenuBrand extends Equatable {
  final int id;
  final int businessId;
  final String title;
  final String logo;
  final String banner;
  final String qrContent;
  final String qrLabel;
  final bool isVirtual;
  final String businessTitle;
  final List<int> branchIds;
  final List<String> branchTitles;

  const MenuBrand({
    required this.id,
    required this.businessId,
    required this.title,
    required this.logo,
    required this.banner,
    required this.qrContent,
    required this.qrLabel,
    required this.isVirtual,
    required this.businessTitle,
    required this.branchIds,
    required this.branchTitles,
  });

  @override
  List<Object?> get props => [id];
}