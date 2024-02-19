import 'package:flutter/material.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:starlight_utils/starlight_utils.dart';

class Quit {
  const Quit();
}

class ForceQuit extends Quit {
  const ForceQuit();
}

class SoftQuit extends Quit {
  const SoftQuit();
}

Future<Result> showErrorDialog<T extends Object>(
  String title,
  String content, {
  String defaultActionButtonLabel = "Ok",
  bool useDefaultAction = true,
  bool showDefaultActionOnRight = true,
  List<Widget> actions = const [],
}) async {
  final result = await StarlightUtils.dialog(
    AlertDialog(
      actionsPadding: const EdgeInsets.only(
        bottom: 10,
        right: 10,
      ),
      shape: const RoundedRectangleBorder(),
      title: Text(title),
      content: Text(content),
      actions: [
        if (useDefaultAction && !showDefaultActionOnRight)
          TextButton(
            onPressed: () {
              StarlightUtils.pop(result: const SoftQuit());
            },
            child: Text(defaultActionButtonLabel),
          ),
        ...actions,
        if (useDefaultAction && showDefaultActionOnRight)
          TextButton(
            onPressed: () {
              StarlightUtils.pop(result: const SoftQuit());
            },
            child: Text(defaultActionButtonLabel),
          )
      ],
    ),
    barrierDismissible: false,
  );
  if (result == null) {
    return const Result(data: ForceQuit());
  }
  if (result is T) return Result(data: result);
  return const Result(data: SoftQuit());
}
