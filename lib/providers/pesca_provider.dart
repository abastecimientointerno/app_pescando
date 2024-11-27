import 'package:flutter/material.dart';
import '../models/pesca_model.dart';
import '../services/api_service.dart';

class PescaProvider with ChangeNotifier {
  PescaResponse? _pescaResponse;
  bool _isLoading = false;

  PescaResponse? get pescaResponse => _pescaResponse;
  bool get isLoading => _isLoading;

  Future<void> fetchPesca(String fechaInicio, String fechaFin) async {
    _isLoading = true;
    notifyListeners();

    try {
      _pescaResponse = await ApiService.consultarPesca(fechaInicio, fechaFin);
    } catch (e) {
      _pescaResponse = PescaResponse(registros: [], mensaje: 'Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
