import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:geekhaven/Pages/home.dart';
import 'package:geekhaven/Pages/profile.dart';
import 'package:geekhaven/Pages/setting.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  late List<Widget> Pages;

  late Home home;
  late Setting setting;
  late Profile profile;
  int currentTabIndex=0;

  @override
  void initState() {
    setting = Setting();
    home = Home();
    profile = Profile();
    Pages = [home, setting,  profile];
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DotCurvedBottomNav(
        height: 70,
        backgroundColor: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.ease,
        //animationDuration: const Duration(milliseconds: 500),
        onTap: (int index){
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white,),
          Icon(Icons.settings,color: Colors.white,),
          Icon(Icons.person_outlined,color: Colors.white,),
        ],),
      body: Pages[currentTabIndex],
    );
  }
}