import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'main.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _direccionController = TextEditingController();
  final _tipoMonedaController = TextEditingController();
  final _cuantoCambioController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final formData = FormData(
        nombre: _nombreController.text,
        cedula: _cedulaController.text,
        direccion: _direccionController.text,
        tipoMoneda: _tipoMonedaController.text,
        cuantoCambio: _cuantoCambioController.text,
      );

      final prefs = await SharedPreferences.getInstance();
      final formsJson = prefs.getStringList('forms') ?? [];
      formsJson.add(jsonEncode(formData.toJson()));
      await prefs.setStringList('forms', formsJson);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plantilla enviada exitosamente')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Llenar Plantilla')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(labelText: 'Cédula'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _tipoMonedaController,
                decoration: const InputDecoration(labelText: 'Tipo de Moneda de Pago'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _cuantoCambioController,
                decoration: const InputDecoration(labelText: 'Cuánto de Cambio'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}