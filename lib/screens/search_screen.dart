import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/core/colors.dart';
import 'package:recipe/screens/widgets/base_component.dart';
import 'package:recipe/services/api_service.dart';
import 'package:recipe/screens/recipe_screen.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';
import '../core/decoration.dart';
import 'package:recipe/providers/meal_provider.dart';
import '../providers/search_provider.dart';
import 'image_search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final backgroundColor = ConstColor().background;
  ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var speechProvider = Provider.of<SpeechToTextProvider>(context);
    final searchProvider = Provider.of<SearchProvider>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
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
                  border: ConstDecoration().outlinedBorder(),
                  enabledBorder: ConstDecoration().outlinedBorder(),
                  focusedBorder: ConstDecoration().outlinedBorder(),
                  suffixIcon: SizedBox(
                    width: 150,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            searchProvider.clearSuggestions();
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
                                                  searchProvider.fetchSuggestions(speechProvider.lastResult?.recognizedWords ?? "", (q) =>apiService.fetchMeals(q));
                                                  searchProvider.clearSuggestions();
                                                  searchProvider.setLoading(true);
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
              onChanged: (query){
                searchProvider.fetchSuggestions(query, (q) =>apiService.fetchMeals(q));
              },
              onSubmitted: (query){
                searchProvider.fetchSuggestions(query, (q) =>apiService.fetchMeals(q));
                searchProvider.clearSuggestions();
                searchProvider.setLoading(true);
              },
            ),
          ),
          Expanded(
            child: Consumer<MealProvider>(
              builder: (context,mealProvider,child){
                if(searchProvider.suggestions.isNotEmpty) {
                  return ListView.builder(
                    itemCount: searchProvider.suggestions.length,
                    itemBuilder: (context, index) {
                      final meal = searchProvider.suggestions[index];
                      bool isFavourite = mealProvider.isFavourite(meal.idMeal);
                      return ListTile(
                        leading: Image.network(meal.strMealThumb ?? ''),
                        title: Text(meal.strMeal),
                        subtitle: Text(meal.strCategory ?? ''),
                        trailing: GestureDetector(
                          onTap: () {
                            mealProvider.addSearchedMeal(meal);
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: backgroundColor,
                            ),
                            child: Center(
                              child: Icon(
                                isFavourite ? Icons.favorite : Icons.favorite_outline,
                                color: isFavourite ? Colors.redAccent : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeScreen(meal: meal)));
                        },
                      );
                    },
                  );
                } else if(searchProvider.isLoading){
                  return Center(child: BaseComponent().loadingCircle(),);
                } else{
                  return const Center(child: Text('No meals found'));
                }
              },
            ),
          ),

        ],
      ),
    );
  }
}