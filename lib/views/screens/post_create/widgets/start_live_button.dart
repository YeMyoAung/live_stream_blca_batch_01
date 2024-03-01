import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_state.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_bloc.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_event.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_state.dart';

class StartLiveButton extends StatelessWidget {
  const StartLiveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveStreamHostBloc liveStreamBloc =
        context.read<LiveStreamHostBloc>();
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: BlocBuilder<LiveStreamHostBloc, LiveStreamBaseState>(
        builder: (_, state) {
          if (state is LiveStreamContentCreateInitialState) {
            return const SizedBox();
          }
          return ElevatedButton(
            style: const ButtonStyle(
              elevation: MaterialStatePropertyAll(0.4),
              padding:
                  MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 5)),
              minimumSize: MaterialStatePropertyAll(
                Size(80, 35),
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(),
              ),
            ),
            onPressed: () {
              liveStreamBloc.add(const LiveStreamContentCreateEvent());
            },
            child: const Text("Start Live"),
          );
        },
      ),
    );
  }
}
