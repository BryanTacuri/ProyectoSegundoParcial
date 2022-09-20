import 'package:app_pizzeria/domain/point/point_domain.dart';
import 'package:flutter/material.dart';

class CreatePointScreen extends StatefulWidget {
  const CreatePointScreen({super.key});

  @override
  State<CreatePointScreen> createState() => _CreatePointScreenState();
}

class _CreatePointScreenState extends State<CreatePointScreen> {
  String namePoint = '';
  String nameOwner = '';
  double lat = 0;
  double lng = 0;
  bool putMyUbication = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creas Punto de Venta'),
      ),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Propietario'),
                ),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Icon(Icons.touch_app),
                    Text('Ubicación'),
                    Expanded(child: Divider()),
                  ],
                ),
                SwitchListTile(
                    value: putMyUbication,
                    title:
                        const Text('Establecer mi ubicación al Punto de Venta'),
                    onChanged: (onChanged) {
                      setState(() {
                        putMyUbication = onChanged;
                      });
                    }),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      PointDomain pointDomain = PointDomain();
                      pointDomain.storePoint(
                          name: 'mi primer',
                          owner: 'danielñ',
                          lat: -0.2,
                          lng: -79);
                    },
                    child: const Text('Guardar'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
