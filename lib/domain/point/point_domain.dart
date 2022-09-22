import 'package:app_pizzeria/data/point/point_data.dart';
import 'package:app_pizzeria/domain/response/domain_response.dart';

class PointDomain {
  final _pointData = PointData();

  //
  Future<DomainResponse> updatePoint(
      {required String name,
      required String owner,
      required String uid,
      required double? lat,
      required double? lng}) async {
    bool status = false;
    String title = '';
    String message = '';
    final response = await _pointData.updatePoint(
        lat: lat, lng: lng, name: name, owner: owner, uid: uid);
    status = response['status'] ?? false;
    title = response['title'] ?? '';
    message = response['message'] ?? '';
    return DomainResponse(status: status, message: message, title: title);
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
