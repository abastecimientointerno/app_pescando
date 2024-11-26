import 'package:flutter/material.dart';

class PescaResult extends StatelessWidget {
  final int totalRegistros;

  const PescaResult({required this.totalRegistros});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Total de registros: $totalRegistros',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
