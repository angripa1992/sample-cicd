class BranchInfo {
  final int countryId;
  final int branchId;
  final int currencyId;
  final int startTime;
  final int endTime;
  final int availabilityMask;
  final String providerIds;
  final String languageCode;

  BranchInfo(
      {required this.countryId,
        required this.branchId,
        required this.currencyId,
        required this.startTime,
        required this.endTime,
        required this.availabilityMask,
        required this.providerIds,
        required this.languageCode});
}