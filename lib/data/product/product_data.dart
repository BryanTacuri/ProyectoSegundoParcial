import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductData {
  final _storageRef = FirebaseStorage.instance.ref();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  Future<Map<String, dynamic>> deleteProduct(
      {required String uidImage, required String uid}) async {
    bool status = false;
    String title = '';
    String message = '';
    try {
      await _storageRef.child(uidImage).delete();
      await _products.doc(uid).delete();

      status = true;
      title = 'Hecho';
      message = 'Producto eliminado correctamente';
    } catch (e) {
      status = false;
      title = 'Error';
      message = 'No se logró eliminar el producto.';
    }
    return {'status': status, 'title': title, 'message': message};
  }

  Future<Map<String, dynamic>> updateProduct(
      {required String urlImage,
      required String uid,
      required double priceProduct,
      required String uidImage,
      required String nameProduct,
      required String descriptionProduct}) async {
    bool status = false;
    String title = '';
    String message = '';
    String currentUrlImage = urlImage;
    String currentUidImage = uidImage;

    try {
      if (!urlImage.startsWith('http')) {
        await _storageRef.child(uidImage).delete();
        File file = File(urlImage);
        currentUidImage = DateTime.now().microsecondsSinceEpoch.toString();
        final response = await _storageRef.child(currentUidImage).putFile(file);
        currentUrlImage = await response.ref.getDownloadURL();
      }
      _products.doc(uid).set({
        'nameProduct': nameProduct,
        'urlImage': currentUrlImage,
        'descriptionProduct': descriptionProduct,
        'priceProduct': priceProduct,
        'uid': uid,
        'uid_image': currentUidImage
      });
      status = true;
      title = 'Hecho';
      message = 'Producto guardado correctamente';
    } catch (e) {
      status = false;
      title = 'Error';
      message = 'No se logró actualizar el producto.';
    }

    return {'status': status, 'title': title, 'message': message};
  }

  Future<Map<String, dynamic>> storeProduct(
      {required String urlImage,
      required double priceProduct,
      required String nameProduct,
      required String descriptionProduct}) async {
    bool status = false;
    String title = '';
    String message = '';
    String uidImage = urlImage.isEmpty
        ? 'product.png'
        : DateTime.now().microsecondsSinceEpoch.toString();
    String currentUrlImage =
        'https://firebasestorage.googleapis.com/v0/b/pizzamellisos.appspot.com/o/product.png?alt=media&token=bf43342d-e6bf-4130-ab10-694e92568b8d';
    try {
      if (urlImage.isNotEmpty) {
        File file = File(urlImage);
        final response = await _storageRef.child(uidImage).putFile(file);
        currentUrlImage = await response.ref.getDownloadURL();
      }
      String reference = DateTime.now().microsecondsSinceEpoch.toString();
      _products.doc(reference).set({
        'nameProduct': nameProduct,
        'urlImage': currentUrlImage,
        'descriptionProduct': descriptionProduct,
        'priceProduct': priceProduct,
        'uid': reference,
        'uid_image': uidImage
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
