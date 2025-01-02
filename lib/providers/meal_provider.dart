import 'dart:core';
import 'package:flutter/material.dart';
import 'package:recipe/model/meal.dart';
import 'package:recipe/services/meal_database.dart';
class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];
  List<Meal> _searchedMeals = [];
  bool _isLoading = false;

  final String? userId; // Add userId
  MealProvider({this.userId});

  List<Meal> get searchedMeals => _searchedMeals;
  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;

  void setMeals(List<Meal> meals) {
    _meals = meals;
    _isLoading = false;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void addSearchedMeal(Meal meal) {
    if(!_searchedMeals.contains(meal)){
      _searchedMeals.add(meal);
    }
    notifyListeners();
  }

  void toggleFavourite(String idMeal) {
    final mealIndex = searchedMeals.indexWhere((meal) => meal.idMeal == idMeal);
    if (mealIndex != -1) {
      _searchedMeals[mealIndex].isFavourite = !_searchedMeals[mealIndex].isFavourite;
      notifyListeners();
    }
    if(userId != null){
      if(_searchedMeals[mealIndex].isFavourite) {
        MealDatabase(userId: userId).saveFavoriteMeals(
            _searchedMeals[mealIndex]);
      }else{
        MealDatabase(userId: userId).removeFavoriteMeal(idMeal);
      }
    }
  }

  bool isFavourite(String idMeal) {
    final mealIndex = _searchedMeals.indexWhere((meal) => meal.idMeal == idMeal);
    if (mealIndex != -1) {
      return _searchedMeals[mealIndex].isFavourite;
    }
    return false;
  }

  Future<void> fetchMeals() async {
    if (userId == null) return;
    _searchedMeals = await MealDatabase(userId: userId).fetchMealsFromDatabase();
    notifyListeners();
  }
}