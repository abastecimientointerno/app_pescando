import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:app_pescando/providers/pesca_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ModernResultadosScreen extends StatelessWidget {
  const ModernResultadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pescaProvider = Provider.of<PescaProvider>(context);
    final registros = pescaProvider.pescaResponse?.registros ?? [];

    double totalPesca = 0;
    for (var registro in registros) {
      double cantidadPesca = double.tryParse(registro['CNPDS']?.toString() ?? '') ?? 0.0;
      totalPesca += cantidadPesca;
    }

    const objetivoPesca = 350898;
    double progreso = (totalPesca / objetivoPesca) * 100;

    String totalPescaFormatted = NumberFormat("#,##0", "es_MX").format(totalPesca);
    String objetivoPescaFormatted = NumberFormat("#,##0", "es_MX").format(objetivoPesca);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2563EB),  // Blue 600
              Color(0xFF1E40AF),  // Blue 900
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with fade and slide animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Reporte',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 48), // Espaciador
                  ],
                ),
              ).animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.5, end: 0, duration: 300.ms),

              // Circular Progress with scale and fade animation
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: CustomPaint(
                            painter: CircularProgressPainter(
                              backgroundColor: Colors.white.withOpacity(0.3),
                              foregroundColor: Colors.white,
                              progress: progreso / 100,
                              strokeWidth: 15,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '${progreso.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Progreso de pesca',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).animate()
                      .scale(duration: 500.ms, delay: Duration(milliseconds: 500))
                      .fadeIn(duration: 500.ms),

                    SizedBox(height: 32),

                    // Details Cards with staggered animation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildDetailCard(
                            context: context,
                            icon: Icons.anchor,
                            title: 'Captura total',
                            value: totalPescaFormatted,
                          ).animate()
                            .fadeIn(duration: 300.ms, delay: 300.ms)
                            .slideX(begin: 0.1, end: 0, duration: 300.ms),
                          SizedBox(height: 16),
                          _buildDetailCard(
                            context: context,
                            icon: Icons.flag,
                            title: 'Cuota de pesca',
                            value: objetivoPescaFormatted,
                          ).animate()
                            .fadeIn(duration: 300.ms, delay: 450.ms)
                            .slideX(begin: 0.1, end: 0, duration: 300.ms),
                          SizedBox(height: 24),

                          // Progress Bar with animation
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Progreso',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${progreso.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: progreso / 100,
                                  backgroundColor: Colors.white.withOpacity(0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ).animate()
                            .fadeIn(duration: 300.ms, delay: 600.ms)
                            .slideX(begin: 0.1, end: 0, duration: 300.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
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
              icon,
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
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final Color backgroundColor;
  final Color foregroundColor;
  final double progress;
  final double strokeWidth;

  CircularProgressPainter({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.progress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Foreground arc
    final foregroundPaint = Paint()
      ..color = foregroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}