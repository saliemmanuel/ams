import 'package:ams/view/widgets/responsive.dart';
import 'package:flutter/material.dart';

class CustomLayoutBuilder extends StatelessWidget {
  final Widget child;
  final double? marginMax;
  final double? marginMin;
  const CustomLayoutBuilder(
      {super.key,
      required this.child,
      this.marginMax = 0.1,
      this.marginMin = 0.1});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Responsive.isMobile(context)
        ? child
        : LayoutBuilder(
            builder: (context, constraints) => Padding(
              padding: EdgeInsets.only(
                  left: constraints.maxWidth < 1024
                      ? size.width * marginMin!
                      : size.width * marginMax!,
                  right: constraints.maxWidth < 1024
                      ? size.width * marginMin!
                      : size.width * marginMax!),
              child: child,
            ),
          );
  }
}
