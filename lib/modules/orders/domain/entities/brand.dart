class Brands {
  final List<Brand> brands;

  Brands(this.brands);
}

class Brand {
  final int id;
  final int businessId;
  final String title;
  final String logo;
  final String banner;
  final String qrContent;
  final String qrLabel;
  final String businessTitle;
  final List<int> branchIds;
  final List<String> branchTitles;
  final List<int> brandCuisines;
  final bool isSelected;

  Brand({
    required this.id,
    required this.businessId,
    required this.title,
    required this.logo,
    required this.banner,
    required this.qrContent,
    required this.qrLabel,
    required this.businessTitle,
    required this.branchIds,
    required this.branchTitles,
    required this.brandCuisines,
    this.isSelected = true,
  });

  Brand copy() {
    return Brand(id: id,
      businessId: businessId,
      title: title,
      logo: logo,
      banner: banner,
      qrContent: qrContent,
      qrLabel: qrLabel,
      businessTitle: businessTitle,
      branchIds: branchIds,
      branchTitles: branchTitles,
      brandCuisines: brandCuisines,
      isSelected: isSelected,
    );
  }

  Brand copyWith({required isSelected}) {
    return Brand(id: id,
      businessId: businessId,
      title: title,
      logo: logo,
      banner: banner,
      qrContent: qrContent,
      qrLabel: qrLabel,
      businessTitle: businessTitle,
      branchIds: branchIds,
      branchTitles: branchTitles,
      brandCuisines: brandCuisines,
      isSelected: isSelected,
    );
  }
}
