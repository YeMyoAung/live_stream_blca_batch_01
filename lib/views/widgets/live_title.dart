import 'package:flutter/material.dart';

class LiveTitle extends StatelessWidget {
  final String title;
  const LiveTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    );
  }
}
