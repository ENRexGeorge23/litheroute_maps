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
    const StoreListsScreen(),
    const StoresMapScreen(),
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        height: 70,
        shadowColor: Colors.white,
        backgroundColor: MyColors.primaryColor,
        onDestinationSelected: (selectedIndex) {
          setState(() {
            _index = selectedIndex;
          });
        },
        selectedIndex: _index,
        destinations: const <NavigationDestination>[
          NavigationDestination(
              icon: Icon(Icons.store_outlined),
              label: 'Store List',
              selectedIcon: Icon(Icons.store_mall_directory_sharp)),
          NavigationDestination(
              icon: Icon(Icons.map), label: 'Store Locations'),
        ],
      ),
    );
  }
}
