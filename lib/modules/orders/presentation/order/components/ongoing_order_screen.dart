import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/ongoing_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/order/observer/filter_observer.dart';

import '../../../../../app/constants.dart';
import '../observer/filter_subject.dart';

class OngoingOrderScreen extends StatefulWidget {
  final FilterSubject subject;
  const OngoingOrderScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<OngoingOrderScreen> createState() => _OngoingOrderScreenState();
}

class _OngoingOrderScreenState extends State<OngoingOrderScreen> with FilterObserver{

  @override
  void initState() {
    filterSubject = widget.subject;
    filterSubject?.addObserver(this, ObserverTag.ONGOING_ORDER);
    super.initState();
  }
  void _fetchOngoingOrder({required bool willShowLoading}) {
    context.read<OngoingOrderCubit>().fetchOngoingOrder(
      willShowLoading: willShowLoading,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Text('ongoing');
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
