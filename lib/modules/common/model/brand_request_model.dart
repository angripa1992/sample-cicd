class BrandRequestModel {
  final int filterByBranch;
  final int page;
  final int size;

  BrandRequestModel({
    required this.filterByBranch,
    this.page = 1,
    this.size = 1000,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'filterByBranch': filterByBranch,
        'page': page,
        'size': size,
      };
}
