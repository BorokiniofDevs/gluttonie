import 'package:flutter/material.dart';
import 'package:gluttonie/data/dummy_data.dart';
import 'package:gluttonie/model/meal.dart';
import 'package:gluttonie/screens/categories.dart';
import 'package:gluttonie/screens/meals.dart';
import 'package:gluttonie/screens/filters.dart';
import 'package:gluttonie/widget/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  final List<Meal> _favoritesMeals = [];

  void _toggleMealFavoriteStatus(Meal meal) {
    var isExisting = _favoritesMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favoritesMeals.remove(meal);
        _showInfoMessage('Meal removed from favorites');
      });
    } else {
      setState(() {
        _favoritesMeals.add(meal);
        // _iconColor = Colors.red;
        _showInfoMessage('Meal added to favorites');
      });
    }
  }

  Map<Filter, bool> _selectedFilters = kInitialFilters;
// SAVE STATE FROM PREVIOUS SCREEN
  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
      print(result);

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
// TO FILTER THE AVAILABLE MEAL ON THE CATEGORIES SCREEN
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
      // iconColor: _iconColor,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoritesMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
        // iconColor: _iconColor,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
