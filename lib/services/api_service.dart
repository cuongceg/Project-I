import 'package:flutter/cupertino.dart';
import 'package:recipe/core/string.dart';
import 'package:recipe/model/food_news.dart';
import 'package:recipe/model/ingredient.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/meal.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService{
  Future<List<Meal>> fetchMeals(String query) async {
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List meals = jsonData['meals'];
      return meals.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<void> openYoutubeVideo(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<FoodNews> fetchFoodNews() async {
    final url = Uri.parse("https://newsdata.io/api/1/latest?apikey=${ConstString.newsAPI}&q=recipe tips");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return FoodNews.fromJson(jsonData);
    } else {
      throw Exception('Failed to load food news');
    }
  }

  Future<Ingredient> detectIngredients(String imageUrl) async {
    String encodedUrl = Uri.encodeFull(imageUrl);
    final String apiUrl = 'https://detect.roboflow.com/food-oszcf/2?api_key=${ConstString.robloflowAPI}&image=$encodedUrl';

    try {
      debugPrint('Requesting: $apiUrl');
      final response = await http.post(Uri.parse(apiUrl));
      debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Ingredient.fromJson(jsonData);
      } else {
        throw Exception('Failed to detect ingredients');
      }
    } catch (e) {
      debugPrint('Error detecting ingredients: $e');
      throw Exception('Failed to detect ingredients');
    }
  }
}