import 'dart:async';
import 'package:flutter/material.dart';
import '../model/meal.dart';

class SearchProvider with ChangeNotifier {
  Timer? _debounce;
  List<Meal> suggestions = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void fetchSuggestions(String query, Function(String) apiCall) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.isNotEmpty) {
        final result = await apiCall(query);
        if(result != null){
          suggestions = result;
        }else{
          suggestions = [];
        }
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void clearSuggestions(){
    suggestions = [];
    notifyListeners();
  }
}
