import 'package:animate_do/animate_do.dart';
import 'package:blood_donar/screenFunction/secreens/HomePage.dart';
import 'package:blood_donar/screenFunction/secreens/profilePage.dart';
import 'package:blood_donar/screenFunction/secreens/searchPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Bottomnavigatorbar extends StatefulWidget {
  const Bottomnavigatorbar({super.key});

  @override
  State<Bottomnavigatorbar> createState() => _BottomnavigatorbarState();
}

class _BottomnavigatorbarState extends State<Bottomnavigatorbar> {
  List Screens = [
    Searchpage(),
    Homepage(),
    Profilepage(),
  ];
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      // Wrap with ZoomIn animation
      duration: const Duration(milliseconds: 500),
      child: Scaffold(
          backgroundColor: Colors.blue,
          bottomNavigationBar: CurvedNavigationBar(
            index: _selectedIndex,
            animationDuration: Duration(milliseconds: 400),
            backgroundColor: Colors.white, // Set a single background color
            color: const Color.fromARGB(209, 228, 225, 225),

            height: 55,
            // weight:55,
            items: [
              Icon(
                CupertinoIcons.search,
                size: 25,
                color: _selectedIndex == 0 ? Colors.red : Colors.black,
              ),
              Icon(
                CupertinoIcons.home,
                size: 25,
                color: _selectedIndex == 1 ? Colors.red : Colors.black,
              ),
              Icon(
                CupertinoIcons.person,
                size: 25,
                color: _selectedIndex == 2 ? Colors.red : Colors.black,
              ),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          body: Screens[_selectedIndex]),
    );
  }
}
