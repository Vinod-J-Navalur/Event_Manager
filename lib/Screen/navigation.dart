import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../profile.dart';
import 'homescreen.dart';
import 'hoted_events.dart';
import 'multihost.dart';

class Navvbar extends StatefulWidget {
  const Navvbar({Key? key}) : super(key: key);

  @override
  State<Navvbar> createState() => _NavvbarState();
}

class _NavvbarState extends State<Navvbar> {
  @override
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          HomeScreen(),
          user_profile(),
          upload_Details(),
          hosted(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? Colors.blue : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: (_page == 1) ? Colors.blue : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: (_page == 2) ? Colors.blue : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: (_page == 3) ? Colors.blue : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
