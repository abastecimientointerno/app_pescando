class Pesca {
  final String idLocalidad;
  final int diasDePesca;

  Pesca({required this.idLocalidad, required this.diasDePesca});

  factory Pesca.fromJson(Map<String, dynamic> json) {
    return Pesca(
      idLocalidad: json['id_localidad'],
      diasDePesca: json['dias_de_pesca'],
    );
  }
}
