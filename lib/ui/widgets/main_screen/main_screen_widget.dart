import 'package:flutter/material.dart';

import 'package:themoviedb_example/ui/navigation/main_navigation.dart';

class MainScreenWidget extends StatefulWidget {
  final ScreenFactory screenFactory;
  const MainScreenWidget({
    Key? key,
    required this.screenFactory,
  }) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;

  void onSelectedTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          widget.screenFactory.makeNewsListWidget(),
          widget.screenFactory.makeMovieListWidget(),
          widget.screenFactory.makeTVListWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter_outlined),
            label: 'Фильмы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_outlined),
            label: 'Сериалы',
          ),
        ],
        onTap: onSelectedTab,
      ),
    );
  }
}
