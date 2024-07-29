import 'package:flutter/material.dart';
import 'package:macro_tracker/models/macro.dart';
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

  bool _hasNaN(Macro macros) {
    return macros.carb.isNaN || macros.fat.isNaN || macros.protein.isNaN;
  }

  @override
  Widget build(BuildContext context) {
    final macroProvider = Provider.of<MacroProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Macro Counter'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
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
              leading: const Icon(Icons.menu_book),
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
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Clear Daily Macros'),
              onTap: () {
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
      ),
      body: _hasNaN(macroProvider.dailyMacros) ||
              _hasNaN(macroProvider.totalIntake)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
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
                    child: Text("Today's Intake",
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  MacroSummary(macro: macroProvider.totalIntake),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addMeal',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddMealEntryScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Meal',
      ),
    );
  }
}
