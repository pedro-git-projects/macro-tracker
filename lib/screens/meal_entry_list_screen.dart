import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macro_tracker/providers/macro_provider.dart';
import 'package:macro_tracker/screens/add_meal_entry_screen.dart';

class MealEntryListScreen extends StatelessWidget {
  const MealEntryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Entries'),
      ),
      body: Consumer<MacroProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.mealEntries.length,
            itemBuilder: (context, index) {
              final mealEntry = provider.mealEntries[index];
              return ListTile(
                title: Text(mealEntry.name),
                subtitle: Text(
                    'Carbs: ${mealEntry.customMacro.carb}g, Fats: ${mealEntry.customMacro.fat}g, Proteins: ${mealEntry.customMacro.protein}g'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddMealEntryScreen(
                              mealEntry: mealEntry,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteMealEntry(mealEntry.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddMealEntryScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
