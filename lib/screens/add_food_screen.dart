import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macro_tracker/providers/macro_provider.dart';
import 'package:macro_tracker/models/food.dart';
import 'package:macro_tracker/models/macro.dart';

class AddFoodScreen extends StatefulWidget {
  final Food? food;
  final int? index;

  const AddFoodScreen({super.key, this.food, this.index});

  @override
  AddFoodScreenState createState() => AddFoodScreenState();
}

class AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _carbController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.food != null) {
      _nameController.text = widget.food!.name;
      _carbController.text = widget.food!.macro.carb.toString();
      _fatController.text = widget.food!.macro.fat.toString();
      _proteinController.text = widget.food!.macro.protein.toString();
      _amountController.text = widget.food!.amount;
    }
  }

  void _addOrUpdateFood() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final double carbs = double.tryParse(_carbController.text) ?? 0;
      final double fats = double.tryParse(_fatController.text) ?? 0;
      final double proteins = double.tryParse(_proteinController.text) ?? 0;
      final String amount = _amountController.text;

      final newFood = Food(
        id: widget.food?.id, // Preserve the id if updating
        name: name,
        macro: Macro(carb: carbs, fat: fats, protein: proteins),
        amount: amount,
      );

      if (widget.food == null) {
        Provider.of<MacroProvider>(context, listen: false).addFood(newFood);
      } else {
        Provider.of<MacroProvider>(context, listen: false)
            .updateFood(widget.index!, newFood);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food == null ? 'Add Food' : 'Edit Food'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Food Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a food name';
                  }
                  return null;
                },
              ),
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
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addOrUpdateFood,
                child: Text(widget.food == null ? 'Add Food' : 'Update Food'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

