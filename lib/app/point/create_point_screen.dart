import 'dart:async';

import 'package:app_pizzeria/app/utils.dart';
import 'package:app_pizzeria/device/gps_device.dart';
import 'package:app_pizzeria/domain/point/point_domain.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  bool gettinMyUbication = false;
  Set<Marker> markers = {};

  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _kLake;
  final _deviceGps = GpsDevice();

  getMyUbication() async {
    setState(() {
      gettinMyUbication = true;
    });
    try {
      final position = await _deviceGps.getCurrentLocation();
      lat = position.latitude;
      lng = position.longitude;

      setState(() {
        gettinMyUbication = false;
        markers = {
          Marker(
              markerId: MarkerId(
                  'circle_id_${DateTime.now().millisecondsSinceEpoch}'),
              position: LatLng(lat, lng),
              infoWindow: const InfoWindow(title: 'Mi Ubicación')),
        };
        _kLake = CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(lat, lng),
            tilt: 59.440717697143555,
            zoom: 18);
      });
    } catch (e) {
      setState(() {
        putMyUbication = false;
        gettinMyUbication = false;
      });
      Utils.showScaffoldNotification(
          context: context,
          message: e.toString(),
          title: 'Error',
          type: 'error');
    }
  }

  @override
  void initState() {
    _kLake = const CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(-2.1810801, -79.900887),
        tilt: 59.440717697143555,
        zoom: 18);
    super.initState();
  }

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
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Nombre'),
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Propietario'),
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
                          title: const Text(
                              'Establecer mi ubicación al Punto de Venta'),
                          onChanged: (onChanged) {
                            setState(() {
                              putMyUbication = onChanged;
                              gettinMyUbication = true;
                            });
                          }),
                      putMyUbication
                          ? SizedBox(
                              width: double.infinity,
                              height: Utils.getSize(context).height * 0.4,
                              child: gettinMyUbication
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : GoogleMap(
                                      initialCameraPosition: _kLake,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      },
                                    ),
                            )
                          : Container(),
                    ],
                  ),
                )),
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
