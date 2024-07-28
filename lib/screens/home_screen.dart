import 'package:flutter/material.dart';
import 'package:macro_tracker/screens/add_food_screen.dart';
import 'package:macro_tracker/screens/add_meal_entry_screen.dart';
import 'package:macro_tracker/screens/food_list_screen.dart';
import 'package:macro_tracker/screens/meal_entry_list_screen.dart';
import 'package:macro_tracker/screens/set_macro_screen.dart';
import 'package:provider/provider.dart';
import 'package:macro_tracker/providers/macro_provider.dart';
import 'package:macro_tracker/widgets/macro_summary.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final macroProvider = Provider.of<MacroProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Macro Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm'),
                  content: const Text(
                      'Are you sure you want to clear daily macros?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        macroProvider.clearDailyMacros();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text('Daily Macro Goals',
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          MacroSummary(macro: macroProvider.dailyMacros),
          const SizedBox(height: 20),
          Center(
            child: Text('Total Intake',
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          MacroSummary(macro: macroProvider.totalIntake),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit_note),
                    title: const Text('Register Meal'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AddMealEntryScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.menu_book),
                    title: const Text('Meal List'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const MealEntryListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.restaurant),
                    title: const Text('Add Food'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AddFoodScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Food List'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const FoodListScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.self_improvement),
                    title: const Text('Set Daily Goals'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SetMacroScreen()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        label: const Text('Options'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
