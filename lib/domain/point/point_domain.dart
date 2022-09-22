import 'package:app_pizzeria/data/point/point_data.dart';
import 'package:app_pizzeria/domain/response/domain_response.dart';

class PointDomain {
  final _pointData = PointData();

  Future<DomainResponse> storePoint(
      {required String name,
      required String owner,
      required double? lat,
      required double? lng}) async {
    bool status = false;
    String title = '';
    String message = '';
    final response =
        await _pointData.addPoint(lat: lat, lng: lng, name: name, owner: owner);
    status = response['status'] ?? false;
    title = response['title'] ?? '';
    message = response['message'] ?? '';
    return DomainResponse(status: status, message: message, title: title);
  }
}
