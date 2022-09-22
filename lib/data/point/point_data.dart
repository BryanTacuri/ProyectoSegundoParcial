import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PointData {
  final CollectionReference _points =
      FirebaseFirestore.instance.collection('points');
  final _storageRef = FirebaseStorage.instance.ref();

  //
  Future<Map<String, dynamic>> updatePoint(
      {required String name,
      required String owner,
      required String urlImage,
      required String uidImage,
      required String uid,
      required double? lat,
      required double? lng}) async {
    bool status = false;
    String title = '';
    String message = '';
    String currentUidImage = uidImage;
    String currentUrlImage = urlImage;
    try {
      if (!urlImage.startsWith('http')) {
        await _storageRef.child(uidImage).delete();
        File file = File(urlImage);
        currentUidImage = DateTime.now().microsecondsSinceEpoch.toString();
        final response = await _storageRef.child(currentUidImage).putFile(file);
        currentUrlImage = await response.ref.getDownloadURL();
      }
      await _points.doc(uid).set({
        'name': name,
        'owner': owner,
        'lat': lat,
        'lng': lng,
        'uid': uid,
        'uidImage': currentUidImage,
        'urlImage': currentUrlImage,
      });
      status = true;
      title = 'Pdv Actualizado';
      message = 'Se ha aztualizado con exito el Pdv: $name';
    } catch (e) {
      status = false;
      title = 'Error';
      message = 'No se logró agregar el pdv. $e';
    }
    return {'status': status, 'title': title, 'message': message};
  }

  Future<Map<String, dynamic>> addPoint(
      {required String name,
      required String owner,
      required String urlImage,
      required double? lat,
      required double? lng}) async {
    bool status = false;
    String title = '';
    String message = '';
    String currentUrlImage = '';
    String uidImage = DateTime.now().microsecondsSinceEpoch.toString();

    try {
      String uidPoint = DateTime.now().microsecondsSinceEpoch.toString();

      if (urlImage.isNotEmpty) {
        File file = File(urlImage);
        final response = await _storageRef.child(uidImage).putFile(file);
        currentUrlImage = await response.ref.getDownloadURL();
      }

      await _points.doc(uidPoint).set({
        'name': name,
        'owner': owner,
        'lat': lat,
        'lng': lng,
        'uidImage': uidImage,
        'urlImage': currentUrlImage,
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
