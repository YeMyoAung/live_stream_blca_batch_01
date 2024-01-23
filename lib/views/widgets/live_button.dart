import 'package:flutter/material.dart';

class LiveButton extends StatelessWidget {
  final Color? color, iconColor;
  final double? width, height;
  final IconData icon;
  final void Function()? onTap;
  final double radius;
  final EdgeInsetsGeometry? padding;
  const LiveButton({
    super.key,
    this.color,
    this.iconColor,
    this.width,
    this.height,
    required this.icon,
    this.onTap,
    this.radius = 18,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
          width: width,
          height: height,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
