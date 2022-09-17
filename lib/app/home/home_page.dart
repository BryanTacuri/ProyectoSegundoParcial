import 'package:app_pizzeria/app/home/drawer/drawer_home.dart';
import 'package:app_pizzeria/app/home/screens_builder/screen_builder.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pizzeria Mellizos'),
        ),
        drawer: DrawerHome(controller: _controller),
        body: ScreensBuilder(
          controller: _controller,
        ));
  }
}
