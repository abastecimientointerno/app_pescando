import 'package:flutter/material.dart';
import '../models/pesca_model.dart';
import '../services/pesca_service.dart';

class PescaProvider with ChangeNotifier {
  List<Pesca> _pescaData = [];
  bool _isLoading = false;

  List<Pesca> get pescaData => _pescaData;
  bool get isLoading => _isLoading;

  final PescaService _pescaService = PescaService();

  Future<void> fetchPesca(String inicio, String fechaFinal) async {
    _isLoading = true;
    notifyListeners();

    try {
      _pescaData = await _pescaService.fetchPescaData(inicio, fechaFinal);
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
