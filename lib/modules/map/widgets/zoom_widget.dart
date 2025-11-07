import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZoomWidget extends StatefulWidget {

  final VoidCallback? zoomOut;
  final VoidCallback? zoomIn;

  const ZoomWidget({super.key, this.zoomOut, this.zoomIn});

  @override
  State<ZoomWidget> createState() => _ZoomWidgetState();
}

class _ZoomWidgetState extends State<ZoomWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón Zoom -
        GestureDetector(
          onTap: widget.zoomOut?.call,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white70,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: const Icon(Icons.remove, size: 28, color: Colors.black87),
          ),
        ),
        const SizedBox(width: 20),
        // Botón Zoom +
        GestureDetector(
          onTap: widget.zoomIn?.call,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white70,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: const Icon(Icons.add, size: 28, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
