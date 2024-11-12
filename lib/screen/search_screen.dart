import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/meal.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Meal>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _mealsFuture = fetchMeals(''); // Initial load with no query
  }

  void _searchMeals() {
    setState(() {
      _mealsFuture = fetchMeals(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Meals')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a meal...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
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
                } else if (snapshot.hasError) {
                  if(_searchController.text.isNotEmpty){
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }else{
                    return const Center(child: Text('Search for a meal...'));
                  }
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No meals found.'));
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

  Future<List<Meal>> fetchMeals(String query) async {
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'); // replace with actual endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List meals = jsonData['meals'];
      return meals.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }
}