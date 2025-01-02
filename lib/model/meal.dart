class Meal {
  final String idMeal;
  final String strMeal;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strYoutube;
  final String? strMealThumb;
  bool isFavourite = false;
  final List<String> ingredients;
  final List<String> measures;

  Meal({
    required this.idMeal,
    required this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strYoutube,
    this.strMealThumb,
    required this.ingredients,
    required this.measures,
    this.isFavourite = false,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      String ingredient = json['strIngredient$i'] ?? '';
      String measure = json['strMeasure$i'] ?? '';
      if (ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure);
      }
    }

    return Meal(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      strYoutube: json['strYoutube'],
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strYoutube': strYoutube,
      'strMealThumb': strMealThumb,
      'isFavourite': isFavourite,
      'ingredients': ingredients,
      'measures': measures,
    };
  }

  // Create Meal from Firestore document
  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      idMeal: map['idMeal'],
      strMeal: map['strMeal'],
      strCategory: map['strCategory'],
      strArea: map['strArea'],
      strInstructions: map['strInstructions'],
      strYoutube: map['strYoutube'],
      strMealThumb: map['strMealThumb'],
      isFavourite: map['isFavourite'] ?? false,
      ingredients: List<String>.from(map['ingredients'] ?? []),
      measures: List<String>.from(map['measures'] ?? []),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Meal otherMeal = other as Meal;
    return idMeal == otherMeal.idMeal;
  }

  @override
  int get hashCode => idMeal.hashCode;
}

