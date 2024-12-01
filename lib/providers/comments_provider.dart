import 'package:flutter/material.dart';

import '../model/comment.dart';
import '../services/comment_service.dart';

class CommentProvider extends ChangeNotifier{
  final CommentServices _commentServices = CommentServices();
  String _mealId = '';

  set mealId(String value){
    _mealId = value;
    notifyListeners();
  }

  String get mealId => _mealId;

  Stream<List<Comment>> get commentsStream {
    if (_mealId.isEmpty) {
      return const Stream.empty();
    }
    return _commentServices.getCommentsForMeal(_mealId);
  }
}