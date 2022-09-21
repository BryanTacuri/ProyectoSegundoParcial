class ProductArgument {
  final String nameProduct;
  final String descriptionProduct;
  final double priceProduct;
  final String urlImage;
  final String uid;
  final String uidImage;

  const ProductArgument(
      {required this.descriptionProduct,
      required this.nameProduct,
      required this.uid,
      required this.uidImage,
      required this.priceProduct,
      required this.urlImage});
}
