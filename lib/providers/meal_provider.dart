import 'dart:core';
import 'package:flutter/material.dart';
import 'package:recipe/model/meal.dart';
class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];
  final List<Meal> _searchedMeals = [];
  bool _isLoading = false;

  List<Meal> get searchedMeals => _searchedMeals;
  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;

  void setMeals(List<Meal> meals) {
    _meals = meals;
    if(meals.isNotEmpty&&!_searchedMeals.contains(meals.first)){
      _searchedMeals.addAll(meals);
    }
    _isLoading = false;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void addSearchedMeal(List<Meal> meal) {
    if(meals.isNotEmpty&&!_searchedMeals.contains(meals.first)){
      _searchedMeals.addAll(meals);
    }
    notifyListeners();
  }

  void clearMeals(){
    meals.clear();
    searchedMeals.clear();
    notifyListeners();
  }

  void toggleFavourite(String idMeal) {
    final mealIndex = searchedMeals.indexWhere((meal) => meal.idMeal == idMeal);
    if (mealIndex != -1) {
      _searchedMeals[mealIndex].isFavourite = !_searchedMeals[mealIndex].isFavourite;
      notifyListeners();
    }
  }

  bool isFavourite(String idMeal) {
    final mealIndex = _searchedMeals.indexWhere((meal) => meal.idMeal == idMeal);
    if (mealIndex != -1) {
      return _searchedMeals[mealIndex].isFavourite;
    }
    return false;
  }
}