import 'package:flutter/material.dart';
import 'package:money_managment/screens/home/screen_home.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndex,
      builder: (BuildContext context, int updatedIndex, Widget? _) =>
          BottomNavigationBar(
        currentIndex: updatedIndex,
        onTap: (newIndex) {
          ScreenHome.selectedIndex.value = newIndex;
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "TRANSACTIONS"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined), label: "CATEGORY")
        ],
      ),
    );
  }
}
