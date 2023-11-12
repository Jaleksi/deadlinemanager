import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final currViewIndex;
  ValueChanged<int> onClick;
  NavBar({ required this.currViewIndex, required this.onClick });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          label: "list",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notification_add),
          label: "new",
        ),
      ],
      currentIndex: currViewIndex,
      onTap: onClick,
      selectedItemColor: Colors.yellow.shade600,
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
    );
  }
}