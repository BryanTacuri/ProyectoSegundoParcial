import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductData {
  final _storageRef = FirebaseStorage.instance.ref();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  Future<Map<String, dynamic>> storeProduct(
      {required String urlImage,
      required double priceProduct,
      required String nameProduct,
      required String descriptionProduct}) async {
    bool status = false;
    String title = '';
    String message = '';
    String currentUrlImage =
        'https://firebasestorage.googleapis.com/v0/b/pizzamellisos.appspot.com/o/images%2Fef33fa42-d6af-478b-abb8-6c076d66c026?alt=media&token=761bdb7a-2bdf-4c9c-8e99-2f14ad95ad74';
    try {
      if (urlImage.isNotEmpty) {
        File file = File(urlImage);
        final response = await _storageRef
            .child(DateTime.now().microsecondsSinceEpoch.toString())
            .putFile(file);
        currentUrlImage = await response.ref.getDownloadURL();
      }
      String reference = DateTime.now().microsecondsSinceEpoch.toString();
      _products.doc(reference).set({
        'nameProduct': nameProduct,
        'urlImage': currentUrlImage,
        'descriptionProduct': descriptionProduct,
        'priceProduct': priceProduct,
        'uid': reference
      });
      // _products.add({});
      status = true;
      title = 'Hecho';
      message = 'Producto guardado correctamente';
    } catch (e) {
      status = false;
      title = 'Error';
      message = 'No se pudo guardar la el producto';
    }
    return {'status': status, 'title': title, 'message': message};
  }
}
