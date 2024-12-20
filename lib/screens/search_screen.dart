import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/screens/widgets/base_component.dart';
import 'package:recipe/services/api_service.dart';
import 'package:recipe/screens/recipe_screen.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';
import '../model/meal.dart';
import 'package:recipe/providers/meal_provider.dart';
import 'image_search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  void _searchMeals()async{
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    mealProvider.setLoading(true);
    List<Meal>? meals = await apiService.fetchMeals(_searchController.text);
    if(meals != null){
      mealProvider.setMeals(meals);
    }else{
      mealProvider.setMeals([]);
    }
  }

  void _searchMealsByVoice(String query)async{
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    mealProvider.setLoading(true);
    List<Meal>? meals = await apiService.fetchMeals(query);
    if(meals != null){
      mealProvider.setMeals(meals);
    }else{
      mealProvider.setMeals([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var speechProvider = Provider.of<SpeechToTextProvider>(context);
    Provider.of<MealProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Search Meals'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: false,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a meal...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: SizedBox(
                  width: 150,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                    title: const Text('Speech to Text'),
                                    content: Consumer<SpeechToTextProvider>(
                                      builder: (context, speechProvider, child) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (speechProvider.isListening)
                                              const Text('Listening...')
                                            else
                                              const Text('Not listening'),
                                            const SizedBox(height: 20),
                                            if (speechProvider.lastResult != null)
                                              Text('Recognized Words: ${speechProvider.lastResult!.recognizedWords}')
                                            else
                                              const Text('No words recognized yet.'),
                                          ],
                                        );
                                      },
                                    ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          onPressed: (){
                                            if(speechProvider.isAvailable){
                                              speechProvider.listen(partialResults: true, localeId: "en_GB");
                                            }else if(speechProvider.isListening){
                                              speechProvider.stop();
                                            }else{
                                              null;
                                            }
                                          },
                                          icon: const Icon(Icons.mic_outlined),
                                        ),
                                        IconButton(
                                            onPressed: (){
                                              if(speechProvider.lastResult?.recognizedWords != null){
                                                _searchMealsByVoice(speechProvider.lastResult!.recognizedWords);
                                                Navigator.pop(context);
                                                _searchController.text = speechProvider.lastResult!.recognizedWords;
                                              }
                                            },
                                            icon: const  Icon(Icons.search_rounded))
                                      ],
                                    )
                                  ],
                                );
                              }
                          );
                          },
                        icon: const Icon(Icons.mic),
                      ),
                      IconButton(
                          onPressed: (){
                            final mealProvider = Provider.of<MealProvider>(context, listen: false);
                            mealProvider.setMeals([]);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ImageSearch()));
                          },
                          icon: const Icon(Icons.camera_alt_outlined)
                      )
                    ],
                  ),
                )
              ),
              onSubmitted: (_) {
                if(_searchController.text.isNotEmpty){
                  _searchMeals();
                }
              },
            ),
          ),
          Expanded(
            child: Consumer<MealProvider>(
              builder: (context, mealProvider, child) {
                if(mealProvider.isLoading){
                  return Center(child: BaseComponent().loadingCircle());
                } else if (mealProvider.meals.isEmpty) {
                  return Center(child: Text(_searchController.text.isNotEmpty ? 'No meals found.' : 'Search for a meal.'));
                }
                return ListView.builder(
                  itemCount: mealProvider.meals.length,
                  itemBuilder: (context, index) {
                    final meal = mealProvider.meals[index];
                    bool isFavourite = mealProvider.isFavourite(meal.idMeal);
                    return ListTile(
                      leading: Image.network(meal.strMealThumb ?? ''),
                      title: Text(meal.strMeal),
                      subtitle: Text(meal.strCategory ?? ''),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeScreen(meal: meal)));
                      },
                      trailing: GestureDetector(
                        onTap: () {
                          mealProvider.toggleFavourite(meal.idMeal);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(!isFavourite ? 'Added to favourite recipes' : 'Removed from favourite recipes'),
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
                              isFavourite ? Icons.favorite : Icons.favorite_outline,
                              color: isFavourite ? Colors.redAccent : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}