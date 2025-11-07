import 'package:flutter/material.dart';

class InfoWidget extends StatefulWidget {
  final double kms;
  final double hours;
  final int min;
  final double tarifa;

  const InfoWidget({
    super.key,
    required this.kms,
    required this.hours,
    required this.min,
    required this.tarifa,
  });

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
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
            const Text("Kms", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.kms.toString()),
            const SizedBox(height: 6),
            const Text("Hrs", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.hours.toStringAsFixed(2)),
            const SizedBox(height: 6),
            const Text("Min", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.min.toString()),
            const SizedBox(height: 6),
            const Text("Tarifa", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.tarifa.toInt().toString()),
          ],
        ),
      ),
    );
  }
}
