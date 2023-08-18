import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../data/model/consumer_protection.dart';
import 'cubit/consumer_protection_cubit.dart';
import 'logged_in_consumer_protection_view.dart';
import 'logged_out_consumer_protection_view.dart';

class ConsumerProtectionView extends StatefulWidget {
  final bool loggedIn;

  const ConsumerProtectionView({Key? key, required this.loggedIn})
      : super(key: key);

  @override
  State<ConsumerProtectionView> createState() => _ConsumerProtectionViewState();
}

class _ConsumerProtectionViewState extends State<ConsumerProtectionView> {
  @override
  void initState() {
    context.read<ConsumerProtectionCubit>().fetchConsumerProtection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumerProtectionCubit, ResponseState>(
      builder: (context, state) {
        if (state is Success<ConsumerProtection?>) {
          if (state.data != null) {
            if (widget.loggedIn) {
              return LoggedInConsumerProtectionView(
                consumerProtection: state.data!,
              );
            } else {
              return LoggedOutConsumerProtectionView(
                consumerProtection: state.data!,
              );
            }
          }
        }
        return const SizedBox();
      },
    );
  }
}
