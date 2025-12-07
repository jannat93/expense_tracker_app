import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ChatbotScreen.dart';
import 'ExpenseChartScreen.dart';
import 'home_screen.dart';


// Define the colors
const Color _darkBg = Color(0xFF141414);
const Color _primaryColor = Color(0xFFBB86FC);
const Color _cardBg = Color(0xFF1E1E1E);
const Color _darkText = Color(0xFF141414);

class MainAppShell extends ConsumerStatefulWidget {
  const MainAppShell({super.key});

  @override
  ConsumerState<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends ConsumerState<MainAppShell> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(), // Index 0: Home
    const ExpenseChartScreen(), // Index 1: Track/Chart
    const Center(
      child: Text(
        "More Options Screen (Under Development)",
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
    ), // Index 2: More
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      body: _widgetOptions.elementAt(_selectedIndex),


      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: _primaryColor,
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatbotScreen()),
          );
        },

        child: const Icon(Icons.psychology_alt, size: 32, color: _darkText),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_outlined),
            activeIcon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.white54,
        backgroundColor: _cardBg,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}