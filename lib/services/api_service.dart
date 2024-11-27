import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pesca_model.dart';

class ApiService {
  static const String _url = "https://node-flota-prd.cfapps.us10.hana.ondemand.com/api/reportePesca/ConsultarPescaDescargada";

  static Future<PescaResponse> consultarPesca(String fechaInicio, String fechaFin) async {
    final Map<String, dynamic> payload = {
      "p_options": [],
      "options": [
        {
          "cantidad": "10",
          "control": "MULTIINPUT",
          "key": "FECCONMOV",
          "valueHigh": fechaFin,
          "valueLow": fechaInicio
        }
      ],
      "p_rows": "",
      "p_user": "JHUAMANCIZA"
    };

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        "Content-Type": "application/json;charset=UTF-8",
        "Accept": "application/json",
      },
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      return PescaResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al consultar la API: ${response.statusCode}');
    }
  }
}
