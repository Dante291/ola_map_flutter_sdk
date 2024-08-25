import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sample_app/map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Optional: define light theme
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),

      // Define dark theme
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          HomePage(),
          // ChatPage(),
          // GroupPage(),
          // ContactPage(),
          // ProfilePage(),
        ],
      ),
      // bottom navigation bar like snap chat
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white60,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.location_outline),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(MingCute.chat_1_line),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(MingCute.search_3_line),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(MingCute.group_line),
            label: "Contact",
          ),
          BottomNavigationBarItem(
            icon: Icon(MingCute.user_1_line),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
