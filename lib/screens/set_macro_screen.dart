import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macro_tracker/providers/macro_provider.dart';
import 'package:macro_tracker/models/macro.dart';

class SetMacroScreen extends StatefulWidget {
  const SetMacroScreen({super.key});

  @override
  SetMacroScreenState createState() => SetMacroScreenState();
}

class SetMacroScreenState extends State<SetMacroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _carbController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();

  void _addMacros() {
    if (_formKey.currentState!.validate()) {
      final double carbs = double.tryParse(_carbController.text) ?? 0;
      final double fats = double.tryParse(_fatController.text) ?? 0;
      final double proteins = double.tryParse(_proteinController.text) ?? 0;

      final newMacros = Macro(carb: carbs, fat: fats, protein: proteins);
      Provider.of<MacroProvider>(context, listen: false).addMacros(newMacros);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Macro Goals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _carbController,
                decoration: const InputDecoration(labelText: 'Carbs (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fatController,
                decoration: const InputDecoration(labelText: 'Fats (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _proteinController,
                decoration: const InputDecoration(labelText: 'Proteins (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addMacros,
                child: const Text('Set Macros'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
