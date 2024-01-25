import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_stream/models/comment_model.dart';

class LiveComments extends StatefulWidget {
  final Widget Function(BuildContext context, Comments comment) builder;
  const LiveComments({
    super.key,
    required this.builder,
  });

  @override
  State<LiveComments> createState() => _LiveCommentsState();
}

class _LiveCommentsState extends State<LiveComments> {
  final ScrollController controller = ScrollController();

  final List<Comments> data = [];

  late final Stream<List<Comments>> s =
      Stream.periodic(const Duration(seconds: 3), (v) {
    data.add(Comments("Hello ${data.length}" * (v + 1)));
    data.sort((p, c) => c.createdAt.compareTo(p.createdAt));
    return data;
  }).asBroadcastStream();

  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription = s.listen((event) {
      controller.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Comments>>(
      stream: s,
      builder: (_, snapshot) {
        final result = snapshot.data ?? [];

        return ListView.separated(
          reverse: true,
          controller: controller,
          padding: const EdgeInsets.only(
            bottom: 120,
            top: 20,
          ),
          separatorBuilder: (_, i) => const SizedBox(
            height: 15,
          ),
          itemCount: result.length,
          itemBuilder: (_, index) {
            return widget.builder(context, result[index]);
          },
        );
      },
    );
  }
}
