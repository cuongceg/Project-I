import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:recipe/model/user.dart';

class UserDatabase{
  String? uid;
  UserDatabase({this.uid});

  final CollectionReference userCollection=FirebaseFirestore.instance.collection('user');

  //update and get stream user information data
  Future updateUserData(UserInformation userInformation) async{
    try{
      return await userCollection.doc(uid).set({
        'uid': uid,
        'name': userInformation.name,
        'email': userInformation.email,
        'password': userInformation.password,
      });
    }
    catch(e){
      debugPrint("Error updating user information: $e");
    }
  }

  List<UserInformation> _authDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return UserInformation(
        uid: doc.id,
        name: data.containsKey('name') ? data['name'] : "",
        email: data.containsKey('email') ? data['email'] : "",
        password: data.containsKey('password') ? data['password'] : "",
      );
    }).toList();
  }

  Stream<List<UserInformation>?> get authData{
    return userCollection.snapshots().map((_authDataFromSnapshot));
  }
}