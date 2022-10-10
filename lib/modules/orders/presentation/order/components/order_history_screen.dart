import 'package:flutter/material.dart';
import 'package:klikit/modules/orders/presentation/order/observer/filter_observer.dart';

import '../../../../../app/constants.dart';
import '../observer/filter_subject.dart';

class OrderHistoryScreen extends StatefulWidget {
  final FilterSubject subject;
  const OrderHistoryScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with FilterObserver {

  @override
  void initState() {
    filterSubject = widget.subject;
    filterSubject?.addObserver(this, ObserverTag.NEW_ORDER);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Text('History');
  }

  @override
  void applyBrandsFilter(List<int> brandsID) {
    // TODO: implement applyBrandsFilter
  }

  @override
  void applyProviderFilter(List<int> providersID) {
    // TODO: implement applyProviderFilter
  }
}
