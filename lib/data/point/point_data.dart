import 'package:cloud_firestore/cloud_firestore.dart';

class PointData {
  final CollectionReference _points =
      FirebaseFirestore.instance.collection('points');

  Future<Map<String, dynamic>> addPoint(
      {required String name,
      required String owner,
      required double? lat,
      required double? lng}) async {
    bool status = false;
    String title = '';
    String message = '';
    try {
      String uidPoint = DateTime.now().microsecondsSinceEpoch.toString();

      await _points.doc(uidPoint).set({
        'name': name,
        'owner': owner,
        'lat': lat,
        'lng': lng,
        'uid': uidPoint
      });
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
