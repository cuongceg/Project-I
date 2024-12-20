import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/screens/recipe_screen.dart';
import '../providers/meal_provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Favourite Recipes'),
        backgroundColor: Colors.white,
      ),
      body: Consumer<MealProvider>(
        builder: (context, mealProvider, child) {
          final favouriteMeals = mealProvider.searchedMeals.where((meal) => meal.isFavourite).toList();
          if(favouriteMeals.isEmpty) {
            return const Center(child: Text('No favourite meals yet!'));
          }else{
            return ListView.builder(
              itemCount: favouriteMeals.length,
              itemBuilder: (context, index) {
                final meal = favouriteMeals[index];
                return ListTile(
                  leading: Image.network(meal.strMealThumb ?? ''),
                  title: Text(meal.strMeal),
                  subtitle: Text(meal.strCategory ?? ''),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipeScreen(meal: meal)));},
                  trailing: GestureDetector(
                    onTap: () {
                      mealProvider.toggleFavourite(meal.idMeal);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(meal.isFavourite ? 'Add to favourite recipes' : 'Remove from favourite recipes'),
                          duration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Icon(
                          meal.isFavourite ? Icons.favorite : Icons.favorite_outline,
                          color: meal.isFavourite ? Colors.redAccent : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      ),
    );
  }
}
