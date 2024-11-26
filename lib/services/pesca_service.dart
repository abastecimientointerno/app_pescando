import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pesca_model.dart';

class PescaService {
  static const String _url = "https://node-flota-prd.cfapps.us10.hana.ondemand.com/api/reportePesca/ConsultarPescaDescargada";

  Future<List<Pesca>> fetchPescaData(String inicio, String fechaFinal) async {
    final headers = {
      "Accept": "*/*",
      "Content-Type": "application/json;charset=UTF-8",
      "Origin": "https://tasaproduccion.launchpad.cfapps.us10.hana.ondemand.com",
    };

    final payload = {
      "p_options": [],
      "options": [
        {
          "cantidad": "10",
          "control": "MULTIINPUT",
          "key": "FECCONMOV",
          "valueHigh": fechaFinal,
          "valueLow": inicio,
        }
      ],
      "p_rows": "",
      "p_user": "JHUAMANCIZA",
    };

    try {
      final response = await http.post(Uri.parse(_url), headers: headers, body: jsonEncode(payload));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> pescaList = data['str_des'];
        return pescaList.map((e) => Pesca.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
