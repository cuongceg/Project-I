import 'package:cloud_firestore/cloud_firestore.dart';

class Comment{
  int id;
  double rate;
  String content;
  String userName;
  DateTime createdAt;

  Comment({required this.id,required this.rate,required this.content,required this.userName,required this.createdAt});

  factory Comment.fromMap(Map<String, dynamic> map){
    return Comment(
      id: map['id'],
      rate: map['rate'],
      content: map['content'],
      userName: map['userName'],
      createdAt: (map['createdAt'] as Timestamp).toDate()
    );
  }
}