class PointsArgument {
  final String name;
  final String owner;
  final double? lat;
  final double? lng;
  final String uid;
  final String uidImage;
  final String urlImage;
  const PointsArgument(
      {required this.lat,
      required this.lng,
      required this.uidImage,
      required this.urlImage,
      required this.name,
      required this.owner,
      required this.uid});
}
