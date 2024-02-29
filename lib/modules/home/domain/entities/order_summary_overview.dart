import 'package:klikit/modules/home/domain/entities/summary_data.dart';

class OrderSummaryOverview {
  final String label;
  final String value;
  final String tooltipMessage;
  final TotalOrder comparisonData;

  OrderSummaryOverview({
    required this.label,
    required this.value,
    required this.tooltipMessage,
    required this.comparisonData,
  });
}
