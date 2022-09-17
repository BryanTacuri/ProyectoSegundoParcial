class DomainResponse {
  final bool status;
  final String message;
  final String title;
  final dynamic data;
  const DomainResponse(
      {required this.status, this.title = '', this.message = '', this.data});
}
