import 'package:flutter/material.dart';

import 'custom_layout_builder.dart';

class AppBody extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? bodys;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment =
      AlignmentDirectional.centerEnd;
  final Widget? drawer;
  final void Function(bool)? onDrawerChanged;
  final Widget? endDrawer;
  final void Function(bool)? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary = true;
  final bool extendBody = false;
  final bool extendBodyBehindAppBar = false;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture = true;
  final bool endDrawerEnableOpenDragGesture = true;
  final String? restorationId;
  const AppBody(
      {super.key,
      this.appBar,
      this.bodys,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.persistentFooterButtons,
      this.drawer,
      this.onDrawerChanged,
      this.endDrawer,
      this.onEndDrawerChanged,
      this.bottomNavigationBar,
      this.bottomSheet,
      this.backgroundColor,
      this.resizeToAvoidBottomInset,
      this.drawerScrimColor,
      this.drawerEdgeDragWidth,
      this.restorationId});

  @override
  Widget build(BuildContext context) {
    return CustomLayoutBuilder(
      child: Scaffold(
        appBar: appBar,
        body: Stack(
          children: [
            bodys!,
          ],
        ),
      ),
    );
  }
}
