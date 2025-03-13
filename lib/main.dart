import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:meosemptyflutter/scroll_to_hide_widget.dart';
import 'package:meosemptyflutter/tabs/notifications_tab.dart';
import 'package:meosemptyflutter/tabs/search_tab.dart';
import 'package:meosemptyflutter/tabs/settings_tab.dart';
import 'tabs/travel_home_tab.dart'; // We'll create this new tab

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      color: Colors.white,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late ScrollController _scrollController;
  late List<Widget> _screens;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _screens = [
      TravelHomeTab(scrollController: _scrollController), // Our new home tab
      SearchTab(),
      NotificationsTab(),
      SettingsTab(),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        // Min height ensures the screen is scrollable even with little content
        height: MediaQuery.of(context).size.height,
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: ScrollToHideWidget(
        scrollController: _scrollController,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Color.fromRGBO(0, 0, 0, 0.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.blue,
                color: Colors.black,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.notifications,
                    text: 'Noti',
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Settings',
                  ),
                ],
                selectedIndex: _currentIndex,
                onTabChange: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
