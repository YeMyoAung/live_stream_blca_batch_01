import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class OnTapCard extends StatelessWidget {
  final String title;

  final void Function()? onTap;

  const OnTapCard({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textColor = theme.textTheme.bodyLarge?.color;
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
