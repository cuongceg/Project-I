import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe/model/meal.dart';

class MealDatabase{
  final String? userId;
  MealDatabase({this.userId});

  final CollectionReference mealsCollection=FirebaseFirestore.instance.collection('meals');

  void saveFavoriteMeals(Meal meal)async{
    final mealCollection = mealsCollection
        .doc(userId)
        .collection('favourite meals');

    try{
      await mealCollection.doc(meal.idMeal).set(meal.toMap());
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<List<Meal>> fetchMealsFromDatabase() async {
    final mealCollection = mealsCollection
        .doc(userId)
        .collection('favourite meals');

    try{
      final snapshot = await mealCollection.get();
      return snapshot.docs
          .map((doc) => Meal.fromMap(doc.data()))
          .toList();
    }catch(e){
      debugPrint(e.toString());
      return [];
    }
  }

  void removeFavoriteMeal(String idMeal) async {
    final mealCollection = mealsCollection
        .doc(userId)
        .collection('favourite meals');

    try{
      await mealCollection.doc(idMeal).delete();
    }catch(e){
      debugPrint(e.toString());
    }
  }
}