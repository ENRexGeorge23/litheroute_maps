import 'package:flutter/material.dart';
import 'package:litheroute_maps/MyColors.dart';
import 'package:litheroute_maps/screens/store_map/stores_map.dart';
import 'package:litheroute_maps/screens/store_table/store_lists.dart';

class HomeManagement extends StatefulWidget {
  const HomeManagement({Key? key}) : super(key: key);

  @override
  State<HomeManagement> createState() => _HomeManagementState();
}

class _HomeManagementState extends State<HomeManagement> {
  final List<Widget> _pages = [
    const StoresMapScreen(),
    const StoreListsScreen()
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.white,
        backgroundColor: MyColors.primaryColor,
        onTap: (selectedIndex) {
          setState(() {
            _index = selectedIndex;
          });
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.map), label: 'Store Locations'),
          BottomNavigationBarItem(
              icon: Icon(Icons.store_mall_directory_sharp),
              label: 'Store List'),
        ],
      ),
    );
  }
}
