import 'package:flutter/material.dart';
import 'package:recipe/core/colors.dart';
import 'package:recipe/core/fonts.dart';
import 'package:recipe/screens/profile_screen.dart';
import 'package:recipe/screens/sign_up_screen.dart';
import 'package:recipe/screens/widgets/base_component.dart';
import 'package:recipe/services/authentication_service.dart';

import '../core/decoration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hint = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final font = ConstFonts().copyWith(fontSize: 16,color: ConstColor().primary);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Image.asset("assets/images/background.jpg",height: height,fit: BoxFit.fill,),
          Align(
            alignment: Alignment.center,
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 120),
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
                        'Sign in to your account',
                        style: ConstFonts().titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Sign in with Google
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
                      const SizedBox(height: 24),

                      // Divider
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
                      const SizedBox(height: 24),

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
                      const SizedBox(height:8),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _showForgotPasswordDialog(context);
                          },
                          child: Text('Forgot password?',style: font,),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Continue Button
                      BaseComponent().continueButton(
                          onPressed: ()async{
                            if(_formKey.currentState!.validate()){
                              final user = await AuthService().signIn(emailController.text.trim(), passwordController.text.trim());
                              if(user!=null){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ProfileScreen()));
                              }else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email or password')));
                              }
                            }
                          },
                          text: "Continue"),
                      const SizedBox(height: 24),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Not a member?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                            },
                            child: Text('Create an account',style: font,),
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
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ConstColor().background,
          title: const Text('Forgot Password'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                border: ConstDecoration().outlinedBorder(),
                focusedBorder: ConstDecoration().outlinedBorder(),
                enabledBorder: ConstDecoration().outlinedBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.grey),),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await AuthService().resetPassword(emailController.text.trim(), (message) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                  });
                  Navigator.of(context).pop();
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email')));
                }
              },
              child: Text('Submit',style: TextStyle(color:ConstColor().primary),),
            ),
          ],
        );
      },
    );
  }
}
