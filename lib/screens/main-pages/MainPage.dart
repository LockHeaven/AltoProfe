import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:AltoProfe/screens/main-pages/Home.dart';
import 'package:AltoProfe/screens/main-pages/Profile.dart';
import 'package:AltoProfe/screens/main-pages/Tutorials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainPage extends StatefulWidget {
  static const routeName = "/student-main-page";
  // const Home({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool dataLoaded = false;
  MethodsProvider methodsProvider;
  FirebaseProvider firebaseProvider;
  double screenWidth;
  double absoluteHeight;
  // List<Widget> screens = [Home()];

  @override
  void didChangeDependencies() {
    if (!dataLoaded) {
      dataLoaded = true;
      screenWidth = MediaQuery.of(context).size.width;
      absoluteHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top;
      methodsProvider = Provider.of<MethodsProvider>(context);
      firebaseProvider = Provider.of<FirebaseProvider>(context);
      methodsProvider.controller =
          PersistentTabController(initialIndex: methodsProvider.currentView);
      firebaseProvider.getTopics();
    }
    super.didChangeDependencies();
  }

  List<Widget> _buildScreens() {
    List<Widget> screens = [];
    if (firebaseProvider.user.type["student"]) {
      screens.add(Home());
    }
    if (firebaseProvider.user.type["tutor"]) {
      screens.add(Tutorials());
    }
    screens.add(Profile());
    return screens;
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    List<PersistentBottomNavBarItem> buttonTabs = [];
    if (firebaseProvider.user.type["student"]) {
      buttonTabs.add(PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Estudiante"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ));
    }
    if (firebaseProvider.user.type["tutor"]) {
      buttonTabs.add(PersistentBottomNavBarItem(
        icon: Icon(Icons.list),
        title: ("Tutor"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ));
    }
    buttonTabs.add(PersistentBottomNavBarItem(
      icon: Icon(Icons.person),
      title: ("Perfil"),
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ));
    return buttonTabs;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: SafeArea(
        child: Scaffold(
            body: PersistentTabView(
          context,
          controller: methodsProvider.controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle
              .style1, // Choose the nav bar style with this property.
        )
            // bottomNavigationBar: BottomNavigationBar(
            //   currentIndex: currentString,
            //   backgroundColor: methodsProvider.blueColor,
            //   selectedItemColor: Colors.white,
            //   onTap: (val) {
            //     setState(() {
            //       currentString = val;
            //     });
            //   },
            //   items: const <BottomNavigationBarItem>[
            //     BottomNavigationBarItem(
            //         icon: Icon(
            //           Icons.home,
            //         ),
            //         label: "Home",
            //         backgroundColor: Colors.red),
            //     BottomNavigationBarItem(
            //         icon: Icon(Icons.ac_unit_rounded),
            //         label: "Home2",
            //         backgroundColor: Colors.green),
            //     BottomNavigationBarItem(
            //         icon: Icon(Icons.work_rounded),
            //         label: "Home3",
            //         backgroundColor: Colors.grey),
            //   ],
            // ),
            ),
      ),
    );
  }
}
