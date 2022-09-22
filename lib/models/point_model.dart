import 'package:cloud_firestore/cloud_firestore.dart';

class PointModel {
  final String pointName;
  final String ownerName;
  final String urlImage;
  final double? lat;
  final double? lng;
  const PointModel(
      {required this.lat,
      required this.lng,
      required this.ownerName,
      required this.pointName,
      required this.urlImage});

  factory PointModel.fromFirebase(
      {required QueryDocumentSnapshot<Object?> pointJson}) {
    return PointModel(
        lat: pointJson['lat'],
        lng: pointJson['lng'],
        ownerName: pointJson['owner'] ?? 'Pepe',
        pointName: pointJson['name'] ?? 'Las Delicias',
        urlImage: pointJson['urlImage'] ?? 'assets/product.png');
  }
}
