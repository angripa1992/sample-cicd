class BusyModeGetResponse {
  bool isBusy;

  BusyModeGetResponse({required this.isBusy});
}

class BusyModePostResponse {
  final String message;
  final List<String> warning;
  final bool isBusy;

  BusyModePostResponse({required this.message, required this.warning,this.isBusy = false,});

  BusyModePostResponse copyWithBusyMode(bool isBusy){
    return BusyModePostResponse(message: message, warning: warning,isBusy: isBusy);
  }
}
