import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/controller/api_service.dart';
import 'package:recipe/screen/recipe_screen.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';
import '../model/meal.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Meal>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _mealsFuture = apiService.fetchMeals(''); // Initial load with no query
  }

  void _searchMeals() {
    setState(() {
      _mealsFuture = apiService.fetchMeals(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var speechProvider = Provider.of<SpeechToTextProvider>(context);
    final mealProvider = Provider.of<MealProvider>(context);
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
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => {
                    if(speechProvider.lastResult?.recognizedWords != null && _searchController.text.isEmpty){
                      setState(() {
                        _searchController.text = speechProvider.lastResult!.recognizedWords;
                      })
                    },
                    _searchMeals()
                  }
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: SizedBox(
                  width: 100,
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
                          if(speechProvider.isAvailable){
                            speechProvider.listen(partialResults: true, localeId: "en_GB");
                          }else if(speechProvider.isListening){
                            speechProvider.stop();
                          }else{
                            null;
                          }
                        },
                        icon: speechProvider.isListening?const Icon(Icons.mic_off_outlined): const Icon(Icons.mic,),
                      ),
                    ],
                  ),
                )
              ),
              onSubmitted: (_) => _searchMeals(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: _mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  if(_searchController.text.isNotEmpty){
                    return const Center(child: Text('No meals found.'));
                  }else{
                    return const Center(child: Text('Search for a meal...'));
                  }
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    mealProvider.setMeals(snapshot.data!);
                  });
                  return ListView.builder(
                    itemCount: mealProvider.meals.length,
                    itemBuilder: (context, index) {
                      final meal = mealProvider.meals[index];
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
              },
            ),
          ),
        ],
      ),
    );
  }
}