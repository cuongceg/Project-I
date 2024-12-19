import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:recipe/screens/favourite_screen.dart';
import 'package:recipe/screens/home_screen.dart';
import 'package:recipe/screens/search_screen.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PersistentTabController _controller;
  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
  ];
  final NavBarStyle _navBarStyle = NavBarStyle.style10;
  final activeColor = const Color(0xFF329932);

  List<Widget> _buildScreens() => const [
    HomeScreen(),
    SearchScreen(),
    FavouriteScreen(),
    Center(child:Text("Trang")),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home_outlined),
      title: "Home",
      activeColorPrimary: activeColor,
      activeColorSecondary: Colors.white,
      inactiveColorPrimary: Colors.grey,
      scrollController: _scrollControllers.first,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search),
      title: "Search",
      activeColorPrimary: activeColor,
      activeColorSecondary: Colors.white,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.favorite_outline),
      title: "Favourite",
      activeColorPrimary: activeColor,
      inactiveColorPrimary: Colors.grey,
      activeColorSecondary: Colors.white
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person_outline_rounded),
      title: "Settings",
      activeColorPrimary: activeColor,
      inactiveColorPrimary: Colors.grey,
      activeColorSecondary: Colors.white,
      scrollController: _scrollControllers.last,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    for (final element in _scrollControllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        backgroundColor: const Color(0xFFF2F4E9),
        items: _navBarsItems(),
        navBarStyle: _navBarStyle,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: false,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: true,
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.once,
        hideOnScrollSettings: HideOnScrollSettings(
          hideNavBarOnScroll: true,
          scrollControllers: _scrollControllers,
        ),
        padding: const EdgeInsets.only(top: 8),
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            duration: Duration(milliseconds: 300),
            screenTransitionAnimationType:
            ScreenTransitionAnimationType.slide,
          ),
          onNavBarHideAnimation: OnHideAnimationSettings(
            duration: Duration(milliseconds: 100),
            curve: Curves.ease,
          ),
        ),
        confineToSafeArea: true,
        navBarHeight: 70,
      ),
    );
  }
}
