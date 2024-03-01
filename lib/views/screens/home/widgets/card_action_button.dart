import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const CardActionButton({
    super.key,
    this.icon = Icons.thumb_up,
    this.label = "like",
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final themeIconColor = theme.textTheme.bodyLarge?.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color ?? themeIconColor,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: color ?? themeIconColor,
            ),
          ),
        ],
      ),
    );
  }
}
