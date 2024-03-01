import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_event.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_state.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_bloc.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_state.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/utils/dialog/error_dialog.dart';
import 'package:starlight_utils/starlight_utils.dart';

class PostCreateLoadingIndicator extends StatelessWidget {
  const PostCreateLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveStreamHostBloc liveStreamBloc =
        context.read<LiveStreamHostBloc>();
    return BlocConsumer<LiveStreamHostBloc, LiveStreamBaseState>(
      builder: (_, state) {
        if (state is LiveStreamContentCreateLoadingState ||
            state is LiveStreamContentCreateInitialState) {
          return Container(
            alignment: Alignment.center,
            width: context.width,
            height: context.height,
            color: const Color.fromRGBO(255, 255, 255, 0.1),
            child: const CupertinoActivityIndicator(),
          );
        }

        return const SizedBox();
      },
      listener: (_, state) async {
        if (state is LiveStreamContentCreateErrorState) {
          final result = await showErrorDialog<bool>(
            "Failed to live",
            state.message,
            useDefaultAction: true,
            defaultActionButtonLabel: "Back",
            showDefaultActionOnRight: false,
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Colors.deepOrangeAccent),
                  foregroundColor: const MaterialStatePropertyAll(Colors.white),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                onPressed: () {
                  StarlightUtils.pop(result: false);
                  liveStreamBloc.add(
                    const LiveStreamSocketConnectEvent(),
                  );
                },
                child: const Text("Retry"),
              )
            ],
          );
          if (result.data is Quit) {
            StarlightUtils.pop();
          }
          return;
        }
        if (state is LiveStreamContentCreateSuccessState) {
          StarlightUtils.pushReplacementNamed(
            RouteNames.host,
            arguments: liveStreamBloc,
          );
        }
      },
    );
  }
}
