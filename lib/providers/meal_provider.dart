import 'package:flutter/material.dart';
import 'package:recipe/model/meal.dart';
class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];

  List<Meal> get meals => _meals;

  void setMeals(List<Meal> meals) {
    _meals = meals;
    notifyListeners();
  }

  void toggleFavourite(String idMeal) {
    final mealIndex = _meals.indexWhere((meal) => meal.idMeal == idMeal);
    if (mealIndex != -1) {
      _meals[mealIndex].isFavourite = !_meals[mealIndex].isFavourite;
      notifyListeners();
    }
  }
}