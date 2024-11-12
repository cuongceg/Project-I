import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/controller/api_service.dart';
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

  void _searchMeals(String? query) {
    setState(() {
      _mealsFuture = apiService.fetchMeals(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var speechProvider = Provider.of<SpeechToTextProvider>(context);
    String hintText = speechProvider.lastResult?.recognizedWords??'Search for a meal...';
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
                hintText: hintText,
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchMeals(speechProvider.lastResult?.recognizedWords??''),
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
              onSubmitted: (_) => _searchMeals(speechProvider.lastResult?.recognizedWords),
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
                  final meals = snapshot.data!;
                  return ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return ListTile(
                        leading: Image.network(meal.strMealThumb ?? ''),
                        title: Text(meal.strMeal),
                        subtitle: Text(meal.strCategory ?? ''),
                        onTap: () {
                          Navigator.pushNamed(context, '/recipe', arguments: meal);
                        },
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