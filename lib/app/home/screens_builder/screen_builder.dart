import 'package:app_pizzeria/app/point/all_points_map.dart';
import 'package:app_pizzeria/app/point/points.dart';
import 'package:app_pizzeria/app/product/show_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class ScreensBuilder extends StatelessWidget {
  const ScreensBuilder({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return const ShowProductsScreen();
          case 1:
            return const PointPage();
          case 2:
            return const AllPointsMapScreen();
          default:
            return Text(
              pageTitle,
              style: theme.textTheme.headline5,
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'My Products';
    case 1:
      return 'My Poitns';
    case 2:
      return 'Mi Cuenta';
    default:
      return 'Not found page';
  }
}
