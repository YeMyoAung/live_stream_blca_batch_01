import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_bloc.dart';
import 'package:live_stream/views/screens/live_stream/widgets/end_live_stream_button.dart';
import 'package:live_stream/views/screens/live_stream/widgets/live_stream_audio_toggle.dart';
import 'package:live_stream/views/widgets/live_count.dart';
import 'package:live_stream/views/widgets/live_remark.dart';
import 'package:starlight_utils/starlight_utils.dart';

class LiveStreamHeader<T extends LiveStreamBaseBloc> extends StatelessWidget {
  const LiveStreamHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<T>();
    final screenWidth = context.width;
    return Container(
      height: 50,
      color: const Color.fromRGBO(0, 0, 0, 0.1),
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const LiveRemark(),
              const SizedBox(
                width: 30,
              ),
              StreamBuilder(
                stream: bloc.service.viewCount,
                builder: (_, snap) {
                  return LiveCount(
                    count: snap.data?.toString() ?? '0',
                  );
                },
              ),
            ],
          ),
          if (bloc.isHost) ...[
            const LiveEndButton(),
          ] else ...[
            LiveAudioToggle<T>()
          ]
        ],
      ),
    );
  }
}
