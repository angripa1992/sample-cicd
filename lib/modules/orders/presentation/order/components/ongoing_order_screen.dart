import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/ongoing_order_cubit.dart';

class OngoingOrderScreen extends StatefulWidget {
  const OngoingOrderScreen({Key? key}) : super(key: key);

  @override
  State<OngoingOrderScreen> createState() => _OngoingOrderScreenState();
}

class _OngoingOrderScreenState extends State<OngoingOrderScreen> {

  @override
  void initState() {
    _fetchOngoingOrder(willShowLoading: true);
    super.initState();
  }
  void _fetchOngoingOrder({required bool willShowLoading}) {
    context.read<OngoingOrderCubit>().fetchOngoingOrder(
      page: 1,
      willShowLoading: willShowLoading,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Text('ongoing');
  }
}
