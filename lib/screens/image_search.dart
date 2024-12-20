import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipe/core/fonts.dart';
import 'package:recipe/screens/recipe_screen.dart';
import 'package:recipe/screens/widgets/base_component.dart';
import 'package:recipe/services/api_service.dart';
import 'package:recipe/utilities/search_utilities.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/colors.dart';
import '../model/ingredient.dart';
import '../model/meal.dart';
import '../providers/meal_provider.dart';

class ImageSearch extends StatefulWidget {
  const ImageSearch({super.key});

  @override
  State<ImageSearch> createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();
  String? _imageUrl;
  bool isDetectedSuccessfully = false;
  late Future<Ingredient?> _ingredientFuture;

  @override
  void initState() {
    super.initState();
    _ingredientFuture = Future.value(null);
  }

  void _searchMeal(String meal)async{
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    mealProvider.setLoading(true);
    List<Meal>? meals = await _apiService.fetchMeals(meal);
    if(meals != null){
      mealProvider.setMeals(meals);
    }else{
      mealProvider.setMeals([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            final mealProvider = Provider.of<MealProvider>(context, listen: false);
            mealProvider.setMeals([]);
            Navigator.pop(context);
          },
        ),
        title: const Text("Image Search"),
        centerTitle: true,
      ),
      body: PopScope(
        onPopInvokedWithResult: (result,_) {
          if (result) {
            final mealProvider = Provider.of<MealProvider>(context, listen: false);
            mealProvider.setMeals([]);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Center(
              child: Container(
                height: 200,
                width: width - 180,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: _imageFile != null ? Image(image: FileImage(File(_imageFile!.path))) : const Icon(Icons.add, size: 30, color: Colors.grey,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20),
              child: Row(
                children: [
                  Text("Upload from: ", style: ConstFonts().copyWith(fontSize: 20, fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton.icon(
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                      style: ButtonStyle(
                          iconColor: const WidgetStatePropertyAll<Color>(Colors.white),
                          backgroundColor: WidgetStatePropertyAll<Color>(ConstColor().primary)
                      ),
                      icon: const Icon(Icons.camera),
                      label: const Text("Camera", style: TextStyle(fontSize: 14, color: Colors.white),),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton.icon(
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                      style: ButtonStyle(
                          iconColor: const WidgetStatePropertyAll<Color>(Colors.white),
                          backgroundColor: WidgetStatePropertyAll<Color>(ConstColor().primary)
                      ),
                      icon: const Icon(Icons.image),
                      label: const Text("Gallery", style: TextStyle(fontSize: 14, color: Colors.white),),),
                  ),
                ],
              ),
            ),
            Center(
                child: GestureDetector(
                  onTap: () {
                    if (_imageFile != null) {
                      _uploadImageToSupabase(_imageFile!);
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 285,
                    decoration: BoxDecoration(
                      color: ConstColor().primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text("Check ", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),),
                    ),
                  ),
                )
            ),
            const SizedBox(height: 20,),
            Center(
              child: FutureBuilder<Ingredient?>(
                future: _ingredientFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return BaseComponent().loadingCircle();
                  } else if (!snapshot.hasData || snapshot.data!.predictions.isEmpty) {
                    return const SizedBox();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final data = snapshot.data!;
                    final ingredients = data.predictions;
                    return ListTile(
                        title: Text('Detect Ingredient: ${ingredients.first.detectedClass}'),
                        trailing: const Icon(Icons.search_rounded),
                        onTap :(){
                          _searchMeal(SearchUtilities().extractString(ingredients.first.detectedClass));
                        }
                    );
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
                    return const SizedBox();
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
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageToSupabase(File imageFile) async {
    try {
      final client = Supabase.instance.client;
      final fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await client.storage.from('images').upload(fileName, imageFile);

      final publicUrl = client.storage.from('images').getPublicUrl(fileName);

      setState(() {
        _imageUrl = publicUrl;
      });

      debugPrint('Image URL: $publicUrl');

      if (_imageUrl != null) {
        setState(() {
          _ingredientFuture = _apiService.detectIngredients(_imageUrl!);
        });
      }

    } catch (e) {
      debugPrint('Error uploading image: $e');
    }
  }
}
