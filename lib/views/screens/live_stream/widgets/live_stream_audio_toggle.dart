import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_bloc.dart';

class LiveAudioToggle<T extends LiveStreamBaseBloc> extends StatelessWidget {
  const LiveAudioToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<T>();

    return StreamBuilder(
      stream: bloc.agoraService.audioMode,
      builder: (_, snap) {
        return IconButton(
          onPressed: bloc.agoraService.audioToggle,
          icon: snap.data == true
              ? const Icon(
                  Icons.volume_up,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.volume_off,
                  color: Colors.white,
                ),
        );
      },
    );
  }
}
