import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalculateControl extends StatefulWidget {
  final VoidCallback? onStartTrip;
  final VoidCallback? onStopTrip;
  final VoidCallback? onStartWait;
  final VoidCallback? onStopWait;

  const CalculateControl({
    super.key,
    this.onStartTrip,
    this.onStopTrip,
    this.onStartWait,
    this.onStopWait,
  });

  @override
  State<CalculateControl> createState() => _CalculateControlState();
}

class _CalculateControlState extends State<CalculateControl> {
  bool viajeActivo = false;
  bool esperaActiva = false;

  void _iniciarViaje() {
    setState(() {
      viajeActivo = true;
      esperaActiva = false;
    });
    _showSnackBar("Viaje iniciado");
    widget.onStartTrip?.call();
  }

  void _detenerViaje() {
    setState(() {
      viajeActivo = false;
      esperaActiva = false;
    });
    _showSnackBar("Viaje finalizado");
    widget.onStopTrip?.call();
  }

  void _iniciarEspera() {
    if (!viajeActivo) return;
    setState(() {
      esperaActiva = true;
    });
    _showSnackBar("Espera iniciada");
    widget.onStartWait?.call();
  }

  void _detenerEspera() {
    setState(() {
      esperaActiva = false;
    });
    _showSnackBar("Espera finalizada");
    widget.onStopWait?.call();
  }

  void _showSnackBar(String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón Viaje
        GestureDetector(
          onTap: viajeActivo ? _detenerViaje : _iniciarViaje,
          child: Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: viajeActivo ? Colors.red : Colors.green,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Icon(
              viajeActivo ? Icons.stop : Icons.local_taxi,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        // Botón Espera
        GestureDetector(
          onTap: viajeActivo
              ? (esperaActiva ? _detenerEspera : _iniciarEspera)
              : null,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: esperaActiva ? Colors.red : Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Icon(
              esperaActiva ? Icons.pause_circle : Icons.timer,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }
}

