import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macro_tracker/providers/macro_provider.dart';
import 'package:macro_tracker/models/food.dart';
import 'package:macro_tracker/models/macro.dart';
import 'package:macro_tracker/models/meal_entry.dart';

class AddMealEntryScreen extends StatefulWidget {
  final MealEntry? mealEntry;
  const AddMealEntryScreen({super.key, this.mealEntry});

  @override
  AddMealEntryScreenState createState() => AddMealEntryScreenState();
}

class AddMealEntryScreenState extends State<AddMealEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _carbController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  List<Food> _selectedFoods = [];

  @override
  void initState() {
    super.initState();
    if (widget.mealEntry != null) {
      _nameController.text = widget.mealEntry!.name;
      _carbController.text = widget.mealEntry!.customMacro.carb.toString();
      _fatController.text = widget.mealEntry!.customMacro.fat.toString();
      _proteinController.text =
          widget.mealEntry!.customMacro.protein.toString();
      _selectedFoods = widget.mealEntry!.foods;
    }
  }

  Macro _calculateTotalMacros() {
    double totalCarbs = 0;
    double totalFats = 0;
    double totalProteins = 0;

    // Sum the macros from the selected foods
    for (var food in _selectedFoods) {
      totalCarbs += food.macro.carb;
      totalFats += food.macro.fat;
      totalProteins += food.macro.protein;
    }

    // Replace or add the custom macros
    double customCarbs = double.tryParse(_carbController.text) ?? 0;
    double customFats = double.tryParse(_fatController.text) ?? 0;
    double customProteins = double.tryParse(_proteinController.text) ?? 0;

    // If custom macros are provided, override the food macros
    if (customCarbs > 0) {
      totalCarbs = customCarbs;
    }
    if (customFats > 0) {
      totalFats = customFats;
    }
    if (customProteins > 0) {
      totalProteins = customProteins;
    }

    return Macro(carb: totalCarbs, fat: totalFats, protein: totalProteins);
  }

  void _addOrUpdateMealEntry() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final Macro totalMacro = _calculateTotalMacros();

      final newMealEntry = MealEntry(
        id: widget.mealEntry?.id,
        name: name,
        foods: _selectedFoods,
        customMacro: totalMacro,
      );

      if (widget.mealEntry == null) {
        Provider.of<MacroProvider>(context, listen: false)
            .addMealEntry(newMealEntry);
      } else {
        Provider.of<MacroProvider>(context, listen: false)
            .updateMealEntry(newMealEntry);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final macroProvider = Provider.of<MacroProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.mealEntry == null ? 'Add Meal Entry' : 'Edit Meal Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Meal Name'),
                validator: (value) {
                  return null;
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: macroProvider.foods.length,
                  itemBuilder: (context, index) {
                    final food = macroProvider.foods[index];
                    return CheckboxListTile(
                      title: Text('${food.name} (${food.serving})'),
                      value: _selectedFoods.contains(food),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedFoods.add(food);
                          } else {
                            _selectedFoods.remove(food);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              TextFormField(
                controller: _carbController,
                decoration:
                    const InputDecoration(labelText: 'Additional Carbs (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  return null;
                },
              ),
              TextFormField(
                controller: _fatController,
                decoration:
                    const InputDecoration(labelText: 'Additional Fats (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  return null;
                },
              ),
              TextFormField(
                controller: _proteinController,
                decoration:
                    const InputDecoration(labelText: 'Additional Proteins (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addOrUpdateMealEntry,
                child: Text(widget.mealEntry == null
                    ? 'Add Meal Entry'
                    : 'Update Meal Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
