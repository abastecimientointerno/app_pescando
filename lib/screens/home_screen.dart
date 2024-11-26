import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pesca_provider.dart';
import '../widgets/pesca_result.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _inicioController = TextEditingController();
  final TextEditingController _finalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pescaProvider = Provider.of<PescaProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Reporte de Pesca')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inicioController,
              decoration: InputDecoration(labelText: 'Fecha Inicio (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _finalController,
              decoration: InputDecoration(labelText: 'Fecha Final (YYYY-MM-DD)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                pescaProvider.fetchPesca(_inicioController.text, _finalController.text);
              },
              child: Text('Consultar'),
            ),
            Expanded(
              child: pescaProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : PescaResult(totalRegistros: pescaProvider.pescaData.length),
            ),
          ],
        ),
      ),
    );
  }
}
