import 'package:app_pizzeria/data/product/product_data.dart';
import 'package:app_pizzeria/domain/response/domain_response.dart';

class ProductDomain {
  final ProductData _productData = ProductData();
  Future<DomainResponse> storeProduct(
      {required String urlImage,
      required double priceProduct,
      required String nameProduct,
      required String descriptionProduct}) async {
    bool status = false;
    String title = '';
    String message = '';

    try {
      final response = await _productData.storeProduct(
          urlImage: urlImage,
          priceProduct: priceProduct,
          nameProduct: nameProduct,
          descriptionProduct: descriptionProduct);
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
}
