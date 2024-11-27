class PescaResponse {
  final List<dynamic> registros;
  final String mensaje;

  PescaResponse({required this.registros, required this.mensaje});

  factory PescaResponse.fromJson(Map<String, dynamic> json) {
    return PescaResponse(
      registros: json['str_des'] ?? [],
      mensaje: json['mensaje'] ?? 'Error',
    );
  }
}
