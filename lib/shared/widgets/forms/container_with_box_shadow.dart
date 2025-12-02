import 'package:flutter/material.dart';

class ContainerWIthBoxShadow extends StatelessWidget {
  final Widget? child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color color;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final BoxShadow? boxShadow;

  const ContainerWIthBoxShadow({
    super.key,
    this.child,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: [
          boxShadow ??
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2), // changes position of shadow
              ),
        ],
      ),
      child: child,
    );
  }
}
