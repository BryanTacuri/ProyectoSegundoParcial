import 'dart:async';
import 'dart:io';

import 'package:app_pizzeria/app/point/arguments/points_arguments.dart';
import 'package:app_pizzeria/app/utils.dart';
import 'package:app_pizzeria/device/gps_device.dart';
import 'package:app_pizzeria/domain/point/point_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePointScreen extends StatefulWidget {
  const UpdatePointScreen({super.key});

  @override
  State<UpdatePointScreen> createState() => _UpdatePointScreenState();
}

class _UpdatePointScreenState extends State<UpdatePointScreen> {
  String namePoint = '';
  String nameOwner = '';
  double? lat;
  double? lng;
  String uidImage = '';
  bool putMyUbication = true;
  String uid = '';
  bool gettinMyUbication = false;
  Set<Marker> markers = {};
  GlobalKey<FormState> myForm = GlobalKey();
  final ImagePicker _imagePicker = ImagePicker();

  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _kLake;
  final _deviceGps = GpsDevice();
  bool isSaving = false;
  String urlImage = '';

  getImage() async {
    XFile? currentImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (currentImage != null) {
      setState(() {
        urlImage = currentImage.path;
      });
    }
  }

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

  updatePoint() async {
    setState(() {
      isSaving = true;
    });
    PointDomain pointDomain = PointDomain();
    try {
      final response = await pointDomain.updatePoint(
          name: namePoint,
          owner: nameOwner,
          lat: lat,
          lng: lng,
          uid: uid,
          uidImage: uidImage,
          urlImage: urlImage);
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
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final args = ModalRoute.of(context)?.settings.arguments as PointsArgument;
      namePoint = args.name;
      nameOwner = args.owner;
      lat = args.lat;
      lng = args.lng;
      uid = args.uid;
      urlImage = args.urlImage;
      uidImage = args.uidImage;
      putMyUbication = false;
      if (lat != null && lng != null) {
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
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Punto de Venta'),
      ),
      body: SafeArea(
        child: uid.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: myForm,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text('Uid: $uid'),
                        SizedBox(
                            height: Utils.getSize(context).height * 0.2,
                            width: Utils.getSize(context).height * 0.2,
                            child: Stack(
                              children: [
                                urlImage.startsWith('http')
                                    ? SizedBox(
                                        height:
                                            Utils.getSize(context).height * 0.2,
                                        width:
                                            Utils.getSize(context).height * 0.2,
                                        child: FadeInImage(
                                            fit: BoxFit.cover,
                                            placeholderErrorBuilder:
                                                (context, error, stackTrace) {
                                              return const Image(
                                                  image: AssetImage(
                                                      'assets/error.jpg'));
                                            },
                                            placeholder: const AssetImage(
                                                'assets/product.png'),
                                            image: NetworkImage(urlImage)),
                                      )
                                    : Image(
                                        height:
                                            Utils.getSize(context).height * 0.2,
                                        width:
                                            Utils.getSize(context).height * 0.2,
                                        image: FileImage(
                                          File(
                                            urlImage,
                                          ),
                                        ),
                                        fit: BoxFit.contain),
                                Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: const Icon(Icons.add_a_photo),
                                      onPressed: () {
                                        getImage();
                                      },
                                    ))
                              ],
                            )),
                        TextFormField(
                          initialValue: namePoint,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              const InputDecoration(labelText: 'Nombre'),
                          validator: _validate,
                          onChanged: (value) {
                            namePoint = value;
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          initialValue: nameOwner,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: _validate,
                          decoration:
                              const InputDecoration(labelText: 'Propietario'),
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
                        lat != null && lng != null
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
                                            onMapCreated: _controller
                                                    .isCompleted
                                                ? null
                                                : (GoogleMapController
                                                    controller) {
                                                    _controller
                                                        .complete(controller);
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
                                                            BorderRadius
                                                                .circular(50)),
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
                                    if (myForm.currentState?.validate() ??
                                        false) {
                                      updatePoint();
                                    } else {
                                      Utils.showScaffoldNotification(
                                          context: context,
                                          title: 'Atención',
                                          type: 'error',
                                          message:
                                              'Ingrese los campos requeridos');
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
