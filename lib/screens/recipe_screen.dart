import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:provider/provider.dart';
import 'package:recipe/core/colors.dart';
import 'package:recipe/core/fonts.dart';
import 'package:recipe/model/comment.dart';
import 'package:recipe/model/user.dart';
import 'package:recipe/providers/comments_provider.dart';
import 'package:recipe/screens/widgets/base_component.dart';
import 'package:recipe/services/comment_service.dart';
import '../services/api_service.dart';
import '../model/meal.dart';
import 'package:recipe/providers/meal_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'login_screen.dart';

class RecipeScreen extends StatefulWidget {
  final Meal meal;
  const RecipeScreen({super.key, required this.meal});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final _scrollController = DraggableScrollableController();
  final _sheet = GlobalKey();
  final commentController = TextEditingController();
  final ValueNotifier<bool> _isButtonVisible = ValueNotifier<bool>(true);
  double rating = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.pixels > 600 && _isButtonVisible.value) {
        _isButtonVisible.value = false;
      } else if (_scrollController.pixels <= 600 && !_isButtonVisible.value) {
        _isButtonVisible.value = true;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final commentsProvider = Provider.of<CommentProvider>(context, listen: false);
      commentsProvider.mealId = widget.meal.idMeal;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isButtonVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentProvider>(context);
    final user = Provider.of<User?>(context);
    final userInformationList = Provider.of<List<UserInformation>?>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    UserInformation? userInformation;
    if(user != null && userInformationList != null){
      userInformation = userInformationList.firstWhere((element) => element.uid == user.uid, orElse: () => UserInformation(uid: '',name: '',email: '',password: ''));
    }
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.network(
                widget.meal.strMealThumb ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 50,
            child:GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                ),
                child: const Center(
                  child: Icon(Icons.arrow_back_rounded,color: Colors.black,),
                ),
              ),
            ),
          ),
          Consumer<MealProvider>(
              builder: (context,mealProvider,child){
                bool isFavourite = mealProvider.isFavourite(widget.meal.idMeal);
                return Positioned(
                  right: 15,
                  top: 50,
                  child:GestureDetector(
                    onTap: (){
                      mealProvider.addSearchedMeal(widget.meal);
                      mealProvider.toggleFavourite(widget.meal.idMeal);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(!isFavourite?'Add to favourite recipes':"Remove to favourite recipes"),
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
                          color: Colors.white
                      ),
                      child: Center(
                        child: Icon(isFavourite ?Icons.favorite:Icons.favorite_outline,color: isFavourite ?Colors.redAccent:Colors.black,),
                      ),
                    ),
                  ),
                );
              }),
          DraggableScrollableSheet(
              key: _sheet,
              initialChildSize: 0.6,
              maxChildSize: 1,
              minChildSize: 0.55,
              expand: true,
              snap: true,
              snapSizes: const [0.55,0.6,0.7,0.8,0.9],
              controller: _scrollController,
              builder:(BuildContext context,ScrollController scrollController){
                return DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Container(
                                height: 5,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          )
                      ),

                      SliverList.list(
                          children:[
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0,top: 8.0,bottom: 8.0),
                              child: Text(
                                widget.meal.strMeal ,
                                style: ConstFonts().headingStyle,
                                softWrap: true,
                                overflow: TextOverflow.clip,
                                maxLines: 3,
                              ),
                            ),
                            headerLine("Ingredients:",ConstFonts().titleStyle),
                            for(int i = 0; i<widget.meal.ingredients.length;i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0,top: 8.0,bottom: 8.0),
                                child: Text(
                                  '- ${widget.meal.ingredients[i]} - ${widget.meal.measures[i]}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            headerLine("Instructions:",ConstFonts().titleStyle),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0,top: 8.0,bottom: 8.0),
                              child: Text(
                                  widget.meal.strInstructions ?? '',
                                  style: ConstFonts().bodyStyle
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            headerLine("Comments:",ConstFonts().titleStyle),
                            StreamBuilder<List<Comment>>(
                                stream: commentsProvider.commentsStream,
                                builder: (context,snapshot){
                                  if(snapshot.connectionState == ConnectionState.waiting){
                                    return Center(child: BaseComponent().loadingCircle(),);
                                  }
                                  final comments = snapshot.data ?? [];
                                  if(comments.isEmpty){
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Center(child: Text('No comments available.Be the first one',style: ConstFonts().copyWith(fontSize: 18),)),
                                    );
                                  }
                                  return Column(
                                    children: [
                                      for (int index = 0; index < comments.length; index++)
                                        ListTile(
                                          leading: const CircleAvatar(
                                            backgroundImage: AssetImage('assets/images/user.png'),
                                            radius: 20,
                                          ),
                                          title: Text("${comments[index].userName} - ${timeago.format(comments[index].createdAt)}",
                                            style: ConstFonts().copyWith(
                                                fontSize:13,
                                                color:ConstColor().tertiary
                                            ),),
                                          subtitle: Text(comments[index].content,style: ConstFonts().bodyStyle,),
                                          trailing: Text('${comments[index].rate.toString()} ⭐️',style: ConstFonts().copyWith(fontSize: 16),),
                                        ),
                                      const SizedBox(height: 20,)
                                    ],
                                  );
                                }
                            ),
                            user!=null?
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5), // Shadow color with opacity
                                        blurRadius: 10, // Blur radius for the shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      ratingStars(),
                                      Padding(
                                        padding: const EdgeInsets.only(left:10,right: 10,bottom: 10),
                                        child: TextField(
                                          controller: commentController,
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white),
                                              ),
                                              focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white),
                                              ),
                                              enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white),
                                              ),
                                              hintText: 'Write a comment',
                                              suffixIcon: IconButton(
                                                  onPressed:(){
                                                    if(commentController.text.isNotEmpty && rating != 0){
                                                      final comment = Comment(
                                                          id: 0,
                                                          rate: rating,
                                                          content: commentController.text,
                                                          userName: user.displayName ?? userInformation!.name ?? '',
                                                          createdAt: DateTime.now()
                                                      );
                                                      CommentServices().createComment(widget.meal.idMeal, comment);
                                                      commentController.clear();
                                                      setState(() {
                                                        rating = 0;
                                                      });
                                                    }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text('Please write a comment and rate the recipe'),
                                                          duration: Duration(milliseconds: 900),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  icon: Icon(Icons.send,color: ConstColor().primary,)
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ):
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                                  child: BaseComponent().continueButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                                      },
                                      text: 'Sign in to comment'
                                  ),
                                ),
                          ]
                      ),
                    ],
                  ),
                );
              }
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isButtonVisible,
              builder: (context, isVisible, child) {
                return AnimatedOpacity(
                  opacity: isVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: isVisible
                      ? Center(
                      child: GestureDetector(
                        onTap: ()async{
                          widget.meal.strYoutube != null?await ApiService().openYoutubeVideo(widget.meal.strYoutube ?? ''):null;
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          decoration: BoxDecoration(
                            color: ConstColor().primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5), // Shadow color with opacity
                                blurRadius: 10, // Blur radius for the shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:  [
                              Icon(Icons.ondemand_video,color: ConstColor().onPrimary,),
                              Text('Watch Video',style: ConstFonts().copyWith(color: ConstColor().onPrimary),),
                            ],
                          ),
                        ),
                      )
                  )
                      : const SizedBox.shrink(),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget headerLine(String title,TextStyle? style){
    return Padding(
      padding: const EdgeInsets.only(left: 12.0,top: 8.0,bottom: 8.0),
      child: Text(
        title,
        style: style??ConstFonts().titleStyle,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget ratingStars(){
    return RatingStars(
      value: rating,
      onValueChanged: (v){
        setState(() {
          rating = v;
        });
      },
      starSize: 50,
      starColor: Colors.amber,
      starOffColor: Colors.grey,
      starBuilder: (index, color) => Icon(
        Icons.star,
        color: color,
      ),
      animationDuration: const Duration(milliseconds: 2000),
    );
  }
}
