import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe/model/comment.dart';

class CommentServices{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Comment>> getCommentsForMeal(String mealId){
    return _firestore.collection('meal').doc(mealId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null || !data.containsKey('comment')) {
        return [];
      }
      try{
        return (data['comment'] as List<dynamic>)
            .map((comment) => Comment.fromMap(comment as Map<String, dynamic>))
            .toList();
      }catch(e){
        debugPrint(e.toString());
        return [];
      }
    });
  }

  Future<void> createComment(String mealId, Comment comment) async {
    final commentMap = comment.toMap();
    final mealDoc = _firestore.collection('meal').doc(mealId);
    final isExist = await mealDoc.get();

    try {
      if (!isExist.exists) {
        await mealDoc.set({
          'comment': [commentMap]
        });
      } else {
        await mealDoc.update({
          'comment': FieldValue.arrayUnion([commentMap])
        });
      }
    } catch (e) {
      debugPrint('Error adding comment: $e');
    }
  }
}