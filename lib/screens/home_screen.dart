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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

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
                          Provider.of<MacroProvider>(context, listen: false)
                              .clearDailyMacros();
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAnimatedFAB(
            context,
            icon: Icons.restaurant,
            label: 'New Meal',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const AddMealEntryScreen()),
              );
            },
            animationValue: 2,
          ),
          const SizedBox(height: 16),
          _buildAnimatedFAB(
            context,
            icon: Icons.fastfood,
            label: 'New Food',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddFoodScreen()),
              );
            },
            animationValue: 1,
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _toggleExpand,
            tooltip: 'Add',
            child: Icon(_isExpanded ? Icons.close : Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedFAB(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required int animationValue,
  }) {
    return AnimatedSlide(
      offset: _isExpanded ? const Offset(0, 0) : const Offset(0, 1),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: _isExpanded ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              borderRadius: BorderRadius.circular(8.0),
              elevation: 4.0,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              heroTag: label,
              onPressed: onPressed,
              mini: true,
              child: Icon(icon),
            ),
          ],
        ),
      ),
    );
  }
}
