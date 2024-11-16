import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:outlined_text/outlined_text.dart';
import 'package:themoviedb/domain/bloc/movies_bloc.dart';
import 'package:themoviedb/domain/bloc/upcoming_bloc.dart';
import 'package:themoviedb/domain/models/movie_model.dart';
import 'package:themoviedb/domain/models/upcoming_model.dart';
import 'package:themoviedb/ui/pages/favourite_page.dart';
import 'package:themoviedb/ui/pages/movie_details_page.dart';
import 'package:themoviedb/ui/pages/search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(
      length: 4,
      vsync: this,
    );

    List<Widget> pages = [
      MainPageContext(tabController: tabController),
      const SearchPage(),
      const FavouritePage(),
    ];

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xff0296E5),
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          unselectedItemColor: const Color(0xff67686D),
          selectedItemColor: const Color(0xff0296E5),
          useLegacyColorScheme: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff242A32),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: SvgPicture.asset(
                  'assets/images/home.svg',
                  color: currentIndex == 0 ? Colors.blue : Colors.grey,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: SvgPicture.asset(
                  'assets/images/search.svg',
                  color: currentIndex == 1 ? Colors.blue : Colors.grey,
                ),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: SvgPicture.asset(
                  'assets/images/save.svg',
                  color: currentIndex == 2 ? Colors.blue : Colors.grey,
                ),
              ),
              label: 'Favourites',
            ),
          ],
        ),
      ),
      body: pages[currentIndex],
    );
  }
}

class MainPageContext extends StatelessWidget {
  const MainPageContext({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          const HomePageSearchBar(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: <Widget>[
                const HomePageTopMovies(),
                HomePageTabBar(controller: tabController),
                const HomePageMoviesGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageMoviesGrid extends StatelessWidget {
  const HomePageMoviesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        if (state is! MoviesLoaded) {
          return const SizedBox(
            height: 250,
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xff0296E5),
              ),
            ),
          );
        }
        final data = state.allMovies.allMovies;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120,
            mainAxisExtent: 230,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) => HomePageMoviesGridItem(
            data: data,
            index: index,
          ),
          itemCount: data.length,
        );
      },
    );
  }
}

class HomePageMoviesGridItem extends StatelessWidget {
  final List<MovieModel> data;
  final int index;

  const HomePageMoviesGridItem({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MovieDetailPage(
                movie: data[index],
              );
            },
          ),
        );
      },
      child: Column(
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              child: CachedNetworkImage(
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff0296E5),
                  ),
                ),
                fit: BoxFit.cover,
                imageUrl:
                    'http://image.tmdb.org/t/p/original/${data[index].backdropPath}',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data[index].title ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageSearchBar extends StatelessWidget {
  const HomePageSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff3A3F47),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Search',
            style: TextStyle(
              color: Color(0xff67686D),
            ),
          ),
          Transform.rotate(
            angle: 180 * math.pi / 360,
            child: SvgPicture.asset('assets/images/search.svg'),
          ),
        ],
      ),
    );
  }
}

class HomePageTopMovies extends StatelessWidget {
  const HomePageTopMovies({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(
      viewportFraction: .47,
      initialPage: 0,
      keepPage: true,
    );
    return SizedBox(
      height: 250,
      child: BlocBuilder<UpcomingBloc, UpcomingState>(
        builder: (context, state) {
          if (state is! UpcomingLoaded) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff0296E5),
              ),
            );
          }

          final data = state.data.results ?? [];

          return PageView.builder(
            controller: controller,
            padEnds: false,
            pageSnapping: false,
            itemBuilder: (context, index) => HomePageTopMoviesItem(
              index: index,
              item: data[index],
            ),
            itemCount: data.length,
          );
        },
      ),
    );
  }
}

class HomePageTopMoviesItem extends StatelessWidget {
  final int index;
  final Results item;

  const HomePageTopMoviesItem(
      {super.key, required this.index, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      height: 250,
      child: Stack(
        children: [
          Positioned(
            left: 30,
            child: SizedBox(
              width: 145,
              height: 210,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff0296E5),
                    ),
                  ),
                  fit: BoxFit.cover,
                  imageUrl:
                      'http://image.tmdb.org/t/p/original/${item.backdropPath}',
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            child: OutlinedText(
              strokes: [
                OutlinedTextStroke(
                  color: const Color(0xff0296E5),
                  width: 3,
                ),
              ],
              text: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 80,
                  color: Color(0xff242A32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageTabBar extends StatelessWidget {
  final TabController controller;

  const HomePageTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MoviesBloc>(context);

    List<Map<String, dynamic>> categories = [
      {
        'title': 'Current',
        'id': 'now_playing',
      },
      {
        'title': 'Popular',
        'id': 'popular',
      },
      {
        'title': 'Top',
        'id': 'top_rated',
      },
      {
        'title': 'Upcoming',
        'id': 'upcoming',
      },
    ];
    List<Tab> tabs = List.generate(
      categories.length,
      (index) {
        return Tab(
          text: categories[index]['title'],
          key: UniqueKey(),
        );
      },
    );
    return TabBar(
      onTap: (index) {
        bloc.add(
          GetMovieInCategoryEvent(
            category: categories[index]['id'],
          ),
        );
      },
      controller: controller,
      dividerColor: Colors.transparent,
      isScrollable: true,
      padding: EdgeInsets.zero,
      tabAlignment: TabAlignment.center,
      indicatorColor: const Color(0xff3A3F47),
      unselectedLabelColor: Colors.white,
      indicatorWeight: 2,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      tabs: tabs,
    );
  }
}
