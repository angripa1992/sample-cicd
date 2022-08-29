import 'package:flutter/material.dart';
import 'package:klikit/core/network/network_connectivity.dart';

import '../../app/di.dart';
import '../widgets/snackbars.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final _networkConnectivity = getIt.get<NetworkConnectivity>();

  @override
  void initState() {
    super.initState();
    _networkConnectivity.init();
    _networkConnectivity.connectivityStream.listen((isOnline) {
      if (isOnline) {
        dismissCurrentSnackBar(context);
      } else {
        showConnectivitySnackBar(context);
      }
    });
  }

  @override
  void dispose() {
    _networkConnectivity.disposeConnectivityStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
