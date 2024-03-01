import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_view_bloc/live_view_cubit.dart';
import 'package:live_stream/controllers/live_view_bloc/live_view_state.dart';

class LiveViewToggle extends StatelessWidget {
  const LiveViewToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LiveViewCubit>();
    return IconButton(
      onPressed: bloc.toggle,
      icon: BlocBuilder<LiveViewCubit, LiveViewState>(
        builder: (_, state) {
          return Icon(
            state is MinimizedLiveViewState
                ? Icons.view_in_ar_outlined
                : Icons.compare_arrows,
            color: Colors.white,
          );
        },
      ),
    );
  }
}
