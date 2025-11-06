import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalculateControl extends StatefulWidget {
  const CalculateControl({super.key});

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
  }

  void _detenerViaje() {
    setState(() {
      viajeActivo = false;
      esperaActiva = false;
    });
  }

  void _iniciarEspera() {
    if (!viajeActivo) return;
    setState(() {
      esperaActiva = true;
    });
  }

  void _detenerEspera() {
    setState(() {
      esperaActiva = false;
    });
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

