import 'package:recipe/core/string.dart';
import 'package:recipe/model/food_news.dart';
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
    final url = Uri.parse("https://newsapi.org/v2/everything?q=food recipe&from=2024-11-02&sortBy=publishedAt&apiKey=${ConstString.newsAPI}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return FoodNews.fromJson(jsonData);
    } else {
      throw Exception('Failed to load food news');
    }
  }
}