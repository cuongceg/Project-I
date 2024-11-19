import 'package:flutter/material.dart';
class Meal {
  final String idMeal;
  final String strMeal;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strYoutube;
  final String? strMealThumb;
  bool isFavourite = false;
  final List<String> ingredients;
  final List<String> measures;

  Meal({
    required this.idMeal,
    required this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strYoutube,
    this.strMealThumb,
    required this.ingredients,
    required this.measures,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      String ingredient = json['strIngredient$i'] ?? '';
      String measure = json['strMeasure$i'] ?? '';
      if (ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure);
      }
    }

    return Meal(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      strYoutube: json['strYoutube'],
      ingredients: ingredients,
      measures: measures,
    );
  }
}

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