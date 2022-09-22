class PointsArgument {
  final String name;
  final String owner;
  final double? lat;
  final double? lng;
  final String uid;
  const PointsArgument(
      {required this.lat,
      required this.lng,
      required this.name,
      required this.owner,
      required this.uid});
}
