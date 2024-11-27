import 'package:app_pescando/screens/resultado_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/pesca_provider.dart';

class ModernPescaScreen extends StatefulWidget {
  const ModernPescaScreen({super.key});

  @override
  State<ModernPescaScreen> createState() => _ModernPescaScreenState();
}

class _ModernPescaScreenState extends State<ModernPescaScreen> {
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              primary: Colors.white,
              surface: Color(0xFF2563EB),
              background: Color(0xFF1E40AF),
            ),
            dialogTheme: DialogTheme(
              backgroundColor: Color(0xFF2563EB),
              titleTextStyle: TextStyle(color: Colors.white),
              contentTextStyle: TextStyle(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Color(0xFF2563EB),
              headerBackgroundColor: Color(0xFF1E40AF),
              headerForegroundColor: Colors.white,
              dayStyle: TextStyle(color: Colors.white),
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return Colors.white70;
              }),
              yearStyle: TextStyle(color: Colors.white),
              todayBackgroundColor:
                  MaterialStateProperty.all(Colors.white.withOpacity(0.2)),
              todayForegroundColor: MaterialStateProperty.all(Colors.white),
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _fechaInicio = pickedDate;
        } else {
          _fechaFin = pickedDate;
        }
      });
    }
  }

  Widget _buildDatePickerCard({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed, // Llama a la función cuando se toque cualquier parte del cuadro
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    selectedDate != null
                        ? _dateFormatter.format(selectedDate)
                        : 'Seleccionar Fecha',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pescaProvider = Provider.of<PescaProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2563EB), // Blue 600
              Color(0xFF1E40AF), // Blue 900
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 24),
                      Text(
                        'Selecciona el periodo',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      _buildDatePickerCard(
                        label: 'Fecha Inicio',
                        selectedDate: _fechaInicio,
                        onPressed: () => _selectDate(context, true),
                      ),

                      const SizedBox(height: 16),

                      _buildDatePickerCard(
                        label: 'Fecha Fin',
                        selectedDate: _fechaFin,
                        onPressed: () => _selectDate(context, false),
                      ),

                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: () {
                          if (_fechaInicio != null && _fechaFin != null) {
                            final fechaInicioFormatted =
                                DateFormat('yyyyMMdd').format(_fechaInicio!);
                            final fechaFinFormatted =
                                DateFormat('yyyyMMdd').format(_fechaFin!);
                            pescaProvider
                                .fetchPesca(fechaInicioFormatted,
                                    fechaFinFormatted)
                                .then((_) {
                              if (pescaProvider.pescaResponse != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ModernResultadosScreen(),
                                  ),
                                );
                              }
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Por favor, selecciona ambas fechas.'),
                                backgroundColor: Colors.white.withOpacity(0.2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Consultar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      if (pescaProvider.isLoading)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SpinKitFadingCircle(
                                color: Colors.white,
                                size: 50.0,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Obteniendo datos...',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (pescaProvider.pescaResponse != null)
                        Center(
                          child: Text(
                            'Registros: ${pescaProvider.pescaResponse!.registros.length}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        Center(
                          child: Text(
                            'Ingresa las fechas para consultar.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
