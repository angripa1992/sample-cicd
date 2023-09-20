class MenuBranchInfo {
  final int branchID;
  final int countryID;
  final int currencyID;
  final int startTime;
  final int endTime;
  final int availabilityMask;
  final String providerIDs;
  final String languageCode;
  final String currencyCode;
  final String currencySymbol;
  final int? businessID;
  final int? brandID;

  MenuBranchInfo({
    required this.businessID,
    required this.brandID,
    required this.branchID,
    required this.countryID,
    required this.currencyID,
    required this.startTime,
    required this.endTime,
    required this.availabilityMask,
    required this.providerIDs,
    required this.languageCode,
    required this.currencyCode,
    required this.currencySymbol,
  });
}
