import 'package:flutter/material.dart';
import 'package:recipe/model/user.dart';
import 'package:recipe/screens/login_screen.dart';
import 'package:recipe/screens/widgets/base_component.dart';
import 'package:recipe/services/user_database.dart';

import '../core/colors.dart';
import '../core/decoration.dart';
import '../core/fonts.dart';
import '../services/authentication_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool hint = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final font = ConstFonts().copyWith(fontSize: 16,color: ConstColor().primary);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result)async{
        if(didPop){
          return;
        }
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
      },
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset("assets/images/background.jpg",height: height,fit: BoxFit.fill,),
            Align(
              alignment: Alignment.center,
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 80),
                color: ConstColor().background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo/Icon
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black,
                          backgroundImage: AssetImage('assets/images/logo.png'),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          'Create new account',
                          style: ConstFonts().titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          validator:(val){
                            if(val==null||val.isEmpty){
                              return "Enter a valid email";
                            }
                            else {
                              return null;
                            }
                          },
                          controller: nameController,
                          cursorColor: Colors.black,
                          decoration: ConstDecoration().inputDecoration(hintText: 'Full Name'),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          validator: (val) {
                            final RegExp gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
                            if (val == null || val.isEmpty) {
                              return "Enter a valid email";
                            } else if (!gmailRegex.hasMatch(val)) {
                              return "Enter a valid gmail address";
                            } else {
                              return null;
                            }
                          },
                          controller: emailController,
                          cursorColor: Colors.black,
                          decoration: ConstDecoration().inputDecoration(hintText: 'Email'),
                        ),
                        const SizedBox(height: 12),
                        // Password TextField
                        TextFormField(
                          validator:(val){
                            if(val==null||val.length < 6){
                              return "Enter a valid password";
                            }
                            else {
                              return null;
                            }
                          },
                          controller: passwordController,
                          cursorColor: Colors.black,
                          obscureText: hint,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: ConstDecoration().outlinedBorder(),
                            focusedBorder: ConstDecoration().outlinedBorder(),
                            enabledBorder: ConstDecoration().outlinedBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hint = !hint;
                                });
                              },
                              icon: Icon(hint ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                        ),
                        const SizedBox(height:12),
                        TextFormField(
                          validator:(val){
                            if(val==null||val.length < 6){
                              return "Enter a valid password";
                            }else if(val!=passwordController.text){
                              return "Password does not match";
                            } else {
                              return null;
                            }
                          },
                          controller: confirmPasswordController,
                          cursorColor: Colors.black,
                          obscureText: hint,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: ConstDecoration().outlinedBorder(),
                            focusedBorder: ConstDecoration().outlinedBorder(),
                            enabledBorder: ConstDecoration().outlinedBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hint = !hint;
                                });
                              },
                              icon: Icon(hint ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Continue Button
                        BaseComponent().continueButton(
                            onPressed: ()async{
                              if(_formKey.currentState!.validate()){
                                final user = await AuthService().signUp(emailController.text.trim(), passwordController.text.trim());
                                if(user!=null){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                                  UserDatabase(uid: user.uid).updateUserData(UserInformation(name: nameController.text, email: emailController.text, password: passwordController.text, uid: user.uid));
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign up successfully')));
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign up failed')));
                                }
                              }
                            },
                            text: "Sign up"),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('Or continue with'),
                            ),
                            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        BaseComponent().signInButton(
                          onPressed: ()async{
                            final user = await AuthService().signInWithGoogle();
                            if(user!=null) {
                              Navigator.pop(context);
                            }
                          },
                          text: 'Sign in with Google',
                          icon: Image.asset('assets/images/google.png', height: 24),
                        ),
                        const SizedBox(height: 12),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                              },
                              child: Text('Sign in',style: font,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
