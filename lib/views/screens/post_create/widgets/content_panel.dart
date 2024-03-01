import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_bloc.dart';

class ContentPanel extends StatelessWidget {
  const ContentPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveStreamHostBloc liveStreamBloc =
        context.read<LiveStreamHostBloc>();
    return TextFormField(
      controller: liveStreamBloc.controller,
      focusNode: liveStreamBloc.focusNode,
      expands: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        hintText: "Type here...",
      ),
    );
  }
}
