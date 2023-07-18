import 'package:flutter/material.dart';
import 'package:themoviedb_example/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb_example/domain/factories/screen_factory.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final _screenFactory = ScreenFactory();

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
            onPressed: () => SessionDataProvider().setSessionId(null),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _screenFactory.makeNewsListWidget(),
          _screenFactory.makeMovieListWidget(),
          _screenFactory.makeTVListWidget(),
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
