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
  double? lat;
  double? lng;
  bool putMyUbication = true;
  bool gettinMyUbication = false;
  Set<Marker> markers = {};
  GlobalKey<FormState> myForm = GlobalKey();

  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _kLake;
  final _deviceGps = GpsDevice();
  bool isSaving = false;

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
              position: LatLng(lat ?? 0, lng ?? 0),
              infoWindow: const InfoWindow(title: 'Mi Ubicación')),
        };
        _kLake = CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(lat ?? 0, lng ?? 0),
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

  gotoBack() {
    Navigator.pop(context);
  }

  savePoint() async {
    setState(() {
      isSaving = true;
    });
    PointDomain pointDomain = PointDomain();
    try {
      final response = await pointDomain.storePoint(
          name: namePoint, owner: nameOwner, lat: lat, lng: lng);
      setState(() {
        isSaving = false;
      });
      if (response.status) {
        gotoBack();
      }
      Utils.showScaffoldNotification(
          context: context,
          title: response.title,
          message: response.message,
          type: response.status ? 'success' : 'error');
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      Utils.showScaffoldNotification(
          context: context,
          message: 'No se pudo guadar el punto de venta.',
          title: 'Oopsss',
          type: 'error');
    }
  }

  @override
  void initState() {
    getMyUbication();
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
          key: myForm,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: _validate,
                    onChanged: (value) {
                      namePoint = value;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validate,
                    decoration: const InputDecoration(labelText: 'Propietario'),
                    onChanged: (value) {
                      nameOwner = value;
                    },
                  ),
                  const SizedBox(
                    height: 25,
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
                        if (!onChanged) {
                          lat = null;
                          lng = null;
                        }
                        setState(() {
                          putMyUbication = onChanged;
                        });
                        getMyUbication();
                      }),
                  putMyUbication
                      ? SizedBox(
                          width: double.infinity,
                          height: Utils.getSize(context).height * 0.3,
                          child: gettinMyUbication
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Stack(
                                  children: [
                                    GoogleMap(
                                      initialCameraPosition: _kLake,
                                      markers: markers,
                                      onMapCreated: _controller.isCompleted
                                          ? null
                                          : (GoogleMapController controller) {
                                              _controller.complete(controller);
                                            },
                                    ),
                                    Positioned(
                                        bottom: 5,
                                        left: 5,
                                        child: IconButton(
                                          icon: Container(
                                              width: 125,
                                              height: 125,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: const Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                              )),
                                          onPressed: () {
                                            getMyUbication();
                                          },
                                        ))
                                  ],
                                ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () {
                              if (myForm.currentState?.validate() ?? false) {
                                savePoint();
                              } else {
                                Utils.showScaffoldNotification(
                                    context: context,
                                    title: 'Atención',
                                    type: 'error',
                                    message: 'Ingrese los campos requeridos');
                              }
                            },
                      child: isSaving
                          ? const CircularProgressIndicator()
                          : const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validate(value) {
    if (value != null && value.trim().isNotEmpty) {
      return null;
    }
    return 'Campo requerido*';
  }
}
