
class InscripcionResponse {
  final String message;
  final String url;
  final String transactionId;
  final String status;

  InscripcionResponse({
    required this.message,
    required this.url,
    required this.transactionId,
    required this.status,
  });

  factory InscripcionResponse.fromJson(Map<String, dynamic> json) {
    return InscripcionResponse(
      message: json['message'] as String,
      url: json['url'] as String,
      transactionId: json['transaction_id'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'url': url,
      'transaction_id': transactionId,
      'status': status,
    };
  }

  bool get esProcesando => status.toLowerCase() == 'procesando';
}