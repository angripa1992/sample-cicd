import 'package:flutter/material.dart';
import 'package:klikit/modules/widgets/dialogs.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: (){
            showAccessDeniedDialog(context: context, role: 'Manager');
          },
          child: Text('Stock Screen'),
        ),
      ),
    );
  }
}
