import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/core/colors.dart';
import 'package:recipe/core/fonts.dart';
import 'package:recipe/screens/recipe_screen.dart';
import 'package:recipe/screens/search_screen.dart';
import 'package:recipe/screens/widgets/base_component.dart';
import '../model/meal.dart';
import '../providers/meal_provider.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService apiService = ApiService();
  late Future<List<Meal>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _mealsFuture = apiService.fetchMeals(''); // Initial load with no query
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text('What would you like to cook today?',
              style: ConstFonts().headingStyle,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 20),
          _headingLine('Recommendations'),
          FutureBuilder<List<Meal>>(
            future: _mealsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: BaseComponent().loadingCircle());
              } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No meals found.'));
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  mealProvider.setMeals(snapshot.data!);
                });
                return SizedBox(
                  height: 270,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mealProvider.meals.length,
                    itemBuilder: (context, index) {
                      final meal = mealProvider.meals[index];
                      return _recipeColumn(meal);
                    },
                  ),
                );
              }
            },
          ),
          _headingLine('Recipes of the week'),
        ],
      ),
    );
  }

  Widget _headingLine(String title){
    return Padding(
      padding: const EdgeInsets.only(left: 12,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: ConstFonts().copyWith(fontWeight: FontWeight.bold,fontSize: 20),),
          TextButton(
            onPressed: (){
              Navigator.push(context,(MaterialPageRoute(builder: (context)=>const SearchScreen())));
            },
            child: Text('See All',style : ConstFonts().copyWith(color: ConstColor().primary,fontSize: 15,fontWeight: FontWeight.w700),),
          ),
        ],
      ),
    );
  }

  Widget _recipeColumn(Meal meal){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>RecipeScreen(meal: meal)));
        },
        child: SizedBox(
          width: 150,
          height: 270,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(meal.strMealThumb ?? '',
                  width: 150,
                  height: 200,
                  fit: BoxFit.cover,),
              ),
              const SizedBox(height: 10),
              Text(
                meal.strMeal,
                style: ConstFonts().copyWith(fontWeight: FontWeight.bold,fontSize: 18),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,),
              const SizedBox(height: 5),
              Text(
                meal.strCategory ?? '',
                style: ConstFonts().copyWith(color: Colors.grey,fontSize: 14),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,),
            ],
          ),
        ),
      ),
    );
  }
}
