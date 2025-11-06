import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoWidget extends StatefulWidget {
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  double km = 0.0;
  double hours = 0.0;
  double tarifa = 0.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Kms", style: TextStyle(fontWeight: FontWeight.bold),),
            Text(km.toStringAsFixed(1)),
            SizedBox(height: 6),
            Text("Hrs", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(hours.toStringAsFixed(1)),
            SizedBox(height: 6),
            Text("Tarifa", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(tarifa.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }

  // 🔄 Ejemplo de cómo actualizar los valores
  void updateStats({double? newKm, double? newHours, double? newTarifa}) {
    setState(() {
      if (newKm != null) km = newKm;
      if (newHours != null) hours = newHours;
      if (newTarifa != null) tarifa = newTarifa;
    });
  }
}
