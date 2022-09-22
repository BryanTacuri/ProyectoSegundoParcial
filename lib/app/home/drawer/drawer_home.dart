import 'package:app_pizzeria/app/utils.dart';
import 'package:app_pizzeria/domain/auth/session.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class DrawerHome extends StatelessWidget {
  final SidebarXController controller;
  final GlobalKey<ScaffoldState> controllerScaffold;
  const DrawerHome(
      {super.key, required this.controller, required this.controllerScaffold});

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: Colors.blueGrey,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white54),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white70,
          ),
          gradient: const LinearGradient(
            colors: [Colors.pink, Colors.indigo],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: Utils.getSize(context).width * 0.7,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 22, 16, 127),
        ),
      ),
      footerDivider: const Divider(),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/logo.png'),
          ),
        );
      },
      items: [
        SidebarXItem(icon: Icons.home, label: 'Mis Productos', onTap: _onClose),
        SidebarXItem(
            icon: Icons.business, label: 'Puntos de Venta', onTap: _onClose),
        SidebarXItem(
            icon: Icons.account_box_rounded,
            label: 'Cerrar Sesión',
            onTap: () {
              LoginDomain loginDomain = LoginDomain();
              loginDomain.closeSession();
            })
      ],
    );
  }

  _onClose() {
    controllerScaffold.currentState?.closeDrawer();
  }
}
