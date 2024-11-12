import 'package:flutter/material.dart';
import 'package:recipe/const_value.dart';

import '../controller/api_service.dart';
import '../model/meal.dart';

class RecipeScreen extends StatefulWidget {
  final Meal meal;
  const RecipeScreen({super.key, required this.meal});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final _scrollController = DraggableScrollableController();
  final _sheet = GlobalKey();
  final ValueNotifier<bool> _isButtonVisible = ValueNotifier<bool>(true);

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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isButtonVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0,top: 8.0,bottom: 8.0),
                                  child: Text(
                                    widget.meal.strMeal ,
                                    style: ConstFonts().headingStyle,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),

                              ],
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
                            color: Colors.blue,
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
                              const Icon(Icons.ondemand_video,color: Colors.white,),
                              Text('Watch Video',style: ConstFonts().copyWith(color: Colors.white),),
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
}
