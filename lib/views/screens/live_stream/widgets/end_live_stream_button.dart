import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_bloc.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_event.dart';

class LiveEndButton extends StatelessWidget {
  const LiveEndButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LiveStreamHostBloc>();
    return SizedBox(
      width: 60,
      height: 30,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Colors.red),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          )),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 4),
          ),
        ),
        onPressed: () {
          bloc.add(const LiveStreamEndEvent());
        },
        child: const Text(
          'End',
        ),
      ),
    );
  }
}
