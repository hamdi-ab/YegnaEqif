import 'package:flutter/material.dart';

class ContainerWIthBoxShadow extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const ContainerWIthBoxShadow({
    Key? key,
    required this.child,
    this.margin,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
