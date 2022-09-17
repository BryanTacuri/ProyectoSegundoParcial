import 'package:cloud_firestore/cloud_firestore.dart';

class PointData {
  final CollectionReference _points =
      FirebaseFirestore.instance.collection('points');

  Future<Map<String, dynamic>> addPoint(
      {required String name,
      required String owner,
      required dynamic lat,
      required dynamic lng}) async {
    bool status = false;
    String title = '';
    String message = '';
    try {
      await _points.add({'name': name, 'owner': owner, 'lat': lat, 'lng': lng});
      status = true;
      title = 'Pdv Agregado';
      message = 'Se ha agregado con exito el Pdv: $name';
    } catch (e) {
      status = false;
      title = 'Error';
      message = 'No se logró agregar el pdv. $e';
    }
    return {'status': status, 'title': title, 'message': message};
  }
}
