import 'package:app_pizzeria/data/point/point_data.dart';
import 'package:app_pizzeria/domain/response/domain_response.dart';

class PointDomain {
  final _pointData = PointData();

  //
  Future<DomainResponse> updatePoint(
      {required String name,
      required String uidImage,
      required String urlImage,
      required String owner,
      required String uid,
      required double? lat,
      required double? lng}) async {
    bool status = false;
    String title = '';
    String message = '';
    final response = await _pointData.updatePoint(
        uidImage: uidImage,
        urlImage: urlImage,
        lat: lat,
        lng: lng,
        name: name,
        owner: owner,
        uid: uid);
    status = response['status'] ?? false;
    title = response['title'] ?? '';
    message = response['message'] ?? '';
    return DomainResponse(status: status, message: message, title: title);
  }

  Future<DomainResponse> deletePoint(
      {required String uid, required String uidImage}) async {
    bool status = false;
    String title = '';
    String message = '';

    try {
      final response = await _pointData.deletePoint(
        uid: uid,
        uidImage: uidImage,
      );
      status = response['status'] ?? false;
      title = response['title'] ?? 'Error';
      message =
          response['message'] ?? 'No se logró obtener información del error';
    } catch (e) {
      status = false;
      title = 'Oops..';
      message = 'Ha ocurrido un error interno';
    }

    return DomainResponse(status: status, title: title, message: message);
  }

  Future<DomainResponse> storePoint(
      {required String name,
      required String owner,
      required String urlImage,
      required double? lat,
      required double? lng}) async {
    bool status = false;
    String title = '';
    String message = '';
    final response = await _pointData.addPoint(
        lat: lat, lng: lng, name: name, owner: owner, urlImage: urlImage);
    status = response['status'] ?? false;
    title = response['title'] ?? '';
    message = response['message'] ?? '';
    return DomainResponse(status: status, message: message, title: title);
  }
}
