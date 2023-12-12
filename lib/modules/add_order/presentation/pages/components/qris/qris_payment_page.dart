import 'package:flutter/material.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/qris/payment_status_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../../app/enums.dart';

class QrisPaymentPage extends StatelessWidget {
  final String paymentLink;
  final int orderID;
  final PaymentState paymentState;
  final _successRedirectBaseUrl = 'https://klikit.io/payment/success';
  final _failedRedirectBaseUrl = 'https://klikit.io/payment/failed';

  const QrisPaymentPage({
    super.key,
    required this.paymentLink,
    required this.orderID,
    required this.paymentState,
  });

  void _navigateToPaymentStatusPage(BuildContext context, bool isSuccessful) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PaymentStatusPage(
          isSuccessful: isSuccessful,
          orderID: orderID,
          paymentState: paymentState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebView(
          initialUrl: paymentLink,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (request) {
            final successRedirectUrl = '$_successRedirectBaseUrl/$orderID';
            final failedRedirectUrl = '$_failedRedirectBaseUrl/$orderID';
            final isPaymentProceed = request.url == successRedirectUrl || request.url == failedRedirectUrl;
            if (isPaymentProceed) {
              final isSuccessful = request.url == successRedirectUrl;
              _navigateToPaymentStatusPage(context, isSuccessful);
            }
            return isPaymentProceed ? NavigationDecision.prevent : NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
