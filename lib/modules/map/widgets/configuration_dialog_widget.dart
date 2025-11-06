import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurationDialog extends StatefulWidget {
  const ConfigurationDialog({super.key});

  @override
  State<ConfigurationDialog> createState() => _ConfigurationDialogState();
}

class _ConfigurationDialogState extends State<ConfigurationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _kmController;
  late TextEditingController _horaController;

  @override
  void initState() {
    super.initState();
    _kmController = TextEditingController();
    _horaController = TextEditingController();
    _loadValues();
  }

  @override
  void dispose() {
    _kmController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  Future<void> _loadValues() async {
    final prefs = await SharedPreferences.getInstance();
    int priceKm = prefs.getInt('price_km') ?? 100;
    int priceHour = prefs.getInt('price_hora') ?? 500;

    setState(() {
      _kmController.text = priceKm.toString();
      _horaController.text = priceHour.toString();
    });
  }

  Future<void> _guardarValores() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final priceKm = int.parse(_kmController.text);
      final priceHour = int.parse(_horaController.text);

      await prefs.setInt('price_km', priceKm);
      await prefs.setInt('price_hora', priceHour);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuración guardada')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Configuración de tarifas"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _kmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Precio por km",
                prefixText: "\$ ",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Ingrese un valor";
                if (double.tryParse(value) == null) return "Debe ser un número";
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _horaController,
              keyboardType:
              TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Precio por hora de espera",
                prefixText: "\$ ",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Ingrese un valor";
                if (double.tryParse(value) == null) return "Debe ser un número";
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _guardarValores,
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
