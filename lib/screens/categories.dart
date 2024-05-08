import 'package:flutter/material.dart';
import 'package:gluttonie/data/dummy_data.dart';
import 'package:gluttonie/model/category.dart';
import 'package:gluttonie/model/meal.dart';
import 'package:gluttonie/screens/meals.dart';
import 'package:gluttonie/widget/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    super.key,
    required this.onToggleFavorite,
    // required this.iconColor,
    required this.availableMeals,
  });

  final void Function(Meal meal) onToggleFavorite;
  // final Color iconColor;
  final List<Meal> availableMeals;

  // void _selectCategory(BuildContext context) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (ctx) => MealsScreen(
  //             title: 'Available Meals',
  //             meals: dummyMeals,
  //             onToggleFavorite: onToggleFavorite,
  //             // iconColor: iconColor,
  //           )));
  // }
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              // _selectCategory(context);
              _selectCategory(context, category);
            },
          )
      ],
    );
  }
}
