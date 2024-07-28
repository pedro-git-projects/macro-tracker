import 'package:flutter/material.dart';
import 'package:macro_tracker/screens/set_macro_screen.dart';
import 'package:provider/provider.dart';
import 'package:macro_tracker/providers/macro_provider.dart';
import 'package:macro_tracker/widgets/food_list_item.dart';
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
        children: [
          MacroSummary(macro: macroProvider.dailyMacros),
          Expanded(
            child: ListView.builder(
              itemCount: macroProvider.foods.length,
              itemBuilder: (context, index) {
                final food = macroProvider.foods[index];
                return FoodListItem(food: food);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SetMacroScreen()),
          );
        },
        label: const Text('Set daily goals'),
        icon: const Icon(Icons.self_improvement),
      ),
    );
  }
}
