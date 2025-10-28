class InscripcionResponse {
  final String message;
  final String transactionId;
  final String status; // Siempre "procesando" inicialmente

  InscripcionResponse({
    required this.message,
    required this.transactionId,
    required this.status,
  });

  factory InscripcionResponse.fromJson(Map<String, dynamic> json) {
    return InscripcionResponse(
      message: json['message'],
      transactionId: json['transaction_id'],
      status: json['status'],
    );
  }
}