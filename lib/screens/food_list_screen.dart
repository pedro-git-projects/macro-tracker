import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macro_tracker/providers/macro_provider.dart';
import 'package:macro_tracker/screens/add_food_screen.dart';

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final macroProvider = Provider.of<MacroProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food List'),
      ),
      body: Consumer<MacroProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.foods.length,
            itemBuilder: (context, index) {
              final food = provider.foods[index];
              return ListTile(
                title: Text(food.name),
                subtitle: Text(
                    'Carbs: ${food.macro.carb}g, Fats: ${food.macro.fat}g, Proteins: ${food.macro.protein}g'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddFoodScreen(
                              food: food,
                              index: index,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteFood(index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
