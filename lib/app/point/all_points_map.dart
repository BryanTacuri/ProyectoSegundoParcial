import 'dart:async';
import 'dart:developer';

import 'package:app_pizzeria/app/utils.dart';
import 'package:app_pizzeria/domain/point/point_domain.dart';
import 'package:app_pizzeria/models/point_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AllPointsMapScreen extends StatefulWidget {
  const AllPointsMapScreen({super.key});

  @override
  State<AllPointsMapScreen> createState() => _AllPointsMapScreenState();
}

class _AllPointsMapScreenState extends State<AllPointsMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  bool isLoading = true;
  int initMarker = 0;
  Set<Marker> markers = {};
  PointDomain pointDomain = PointDomain();
  List<PointModel> points = [];
  CameraPosition kLake = const CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-2.1810801, -79.900887),
      tilt: 59.440717697143555,
      zoom: 18);

  buildKLake({required double lat, required double lng}) {
    kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, lng),
        tilt: 59.440717697143555,
        zoom: 18);
    goToTheLake();
  }

  goToNext() {
    if (initMarker == (markers.length - 1)) {
      initMarker = -1;
    }
    initMarker++;
    buildKLake(
        lat: markers.elementAt(initMarker).position.latitude,
        lng: markers.elementAt(initMarker).position.longitude);
  }

  goToBefore() {
    if (initMarker == 0) {
      initMarker = markers.length;
    }
    initMarker--;
    buildKLake(
        lat: markers.elementAt(initMarker).position.latitude,
        lng: markers.elementAt(initMarker).position.longitude);
  }

  Future<void> goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
  }

  getAllPoints() async {
    final data = await pointDomain.getAllPoints();
    points = data.data;
    for (int x = 0; x < points.length; x++) {
      if (points[x].lat != null && points[x].lng != null) {
        markers.add(
          Marker(
              markerId: MarkerId(
                  'circle_id_${DateTime.now().millisecondsSinceEpoch}_$x'),
              position: LatLng(points[x].lat!, points[x].lng!),
              infoWindow: InfoWindow(title: points[x].pointName)),
        );
      }
    }
    initMarker = markers.length - 1;
    buildKLake(
        lat: markers.last.position.latitude,
        lng: markers.last.position.longitude);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllPoints();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
              height: Utils.getSize(context).height,
              width: Utils.getSize(context).width,
              child: GoogleMap(
                initialCameraPosition: kLake,
                markers: markers,
                onMapCreated: (controller) {
                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  }
                },
              )),
          !isLoading && points.isNotEmpty
              ? Positioned(
                  left: ((Utils.getSize(context).width) / 2) -
                      ((Utils.getSize(context).width * 0.3) / 2),
                  child: SizedBox(
                    width: Utils.getSize(context).width * 0.3,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              goToBefore();
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        IconButton(
                            onPressed: () {
                              goToNext();
                            },
                            icon: const Icon(Icons.arrow_forward_ios))
                      ],
                    ),
                  ),
                )
              : Container(),
          isLoading
              ? Container(
                  color: const Color.fromARGB(92, 0, 0, 0),
                  height: Utils.getSize(context).height,
                  width: Utils.getSize(context).width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Text(
                        'Obteniendo Puntos De Venta',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ))
              : Container()
        ],
      ),
    );
  }
}
