import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/core/colors.dart';
import 'package:recipe/core/fonts.dart';
import 'package:recipe/screens/widgets/base_component.dart';
import 'package:recipe/services/authentication_service.dart';

import '../model/user.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final userInformationList = Provider.of<List<UserInformation>?>(context);
    UserInformation? userInformation;
    if(user != null && userInformationList != null){
      userInformation = userInformationList.firstWhere((element) => element.uid == user.uid, orElse: () => UserInformation(uid: '',name: '',email: '',password: ''));
    }
    return Scaffold(
      backgroundColor: ConstColor().background,
      appBar: AppBar(
        backgroundColor: ConstColor().background,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: user != null ?
      Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage:user.photoURL != null ? NetworkImage(user.photoURL!) : const AssetImage('assets/images/user.png'),
            ),
            title: Text(user.displayName ?? userInformation!.name ?? '',style: ConstFonts().copyWith(fontSize: 20,fontWeight: FontWeight.bold),),
            subtitle: Text(user.email ?? '',style: ConstFonts().copyWith(fontSize: 14,fontWeight:FontWeight.w300,color: Colors.grey),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
            child: BaseComponent().continueButton(
                onPressed: ()async{
                  await AuthService().signOut();
                },
                text: "Sign Out"
            ),
          )
        ],
      ):
     Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         const Center(child: Text('Please sign in to view your profile.',style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),)),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
           child: BaseComponent().continueButton(
               onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
               },
               text: "Sign In"
           ),
         )
       ],
     )
    );
  }
}
