import 'package:flutter/material.dart';

enum MapOrientationMode {
  northUp,
  followHeading,
  free,
}

class OrientationControls extends StatefulWidget {
  final Function(MapOrientationMode) onModeChanged;

  const OrientationControls({super.key, required this.onModeChanged});

  @override
  State<OrientationControls> createState() => _OrientationControlsState();
}

class _OrientationControlsState extends State<OrientationControls> {
  MapOrientationMode _currentMode = MapOrientationMode.northUp;

  void _cycleMode() {
    setState(() {
      _currentMode = MapOrientationMode.values[
      (_currentMode.index + 1) % MapOrientationMode.values.length];
    });

    widget.onModeChanged(_currentMode);
    _showSnackBar(_getTooltip());
  }

  IconData _getIcon() {
    switch (_currentMode) {
      case MapOrientationMode.northUp:
        return Icons.explore; // brújula
      case MapOrientationMode.followHeading:
        return Icons.navigation; // flecha dinámica
      case MapOrientationMode.free:
        return Icons.threed_rotation; // modo libre
    }
  }

  String _getTooltip() {
    switch (_currentMode) {
      case MapOrientationMode.northUp:
        return "Orientación al norte";
      case MapOrientationMode.followHeading:
        return "Orientación del movimiento";
      case MapOrientationMode.free:
        return "Orientación libre";
    }
  }

  Color _getColor() {
    switch (_currentMode) {
      case MapOrientationMode.northUp:
        return Colors.blueAccent;
      case MapOrientationMode.followHeading:
        return Colors.orangeAccent;
      case MapOrientationMode.free:
        return Colors.grey;
    }
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
    return Positioned(
      top: 20,
      left: 10,
      child: GestureDetector(
        onTap: _cycleMode,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white70,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(
            _getIcon(),
            color: _getColor(),
            size: 30,
          ),
        ),
      ),
    );
  }
}
