import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:themoviedb/domain/models/movie_model.dart';

class MovieDetailPage extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailPage({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
        title: const Text(
          'Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_outline_outlined),
            color: Colors.white,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: MovieDetailsPageContent(
        movie: movie,
      ),
    );
  }
}

class MovieDetailsPageContent extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsPageContent({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 400,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Image(
                  // image: AssetImage('assets/images/bg.png'),
                  image: NetworkImage(
                      'http://image.tmdb.org/t/p/original/${movie.backdropPath}'),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 320,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 16,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'http://image.tmdb.org/t/p/original/${movie.posterPath}'),
                    width: 95,
                    height: 120,
                  ),
                ),
              ),
              Positioned(
                bottom: 90,
                right: 10,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Container(
                      width: 54,
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(37, 40, 54, 0.3),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.star_border_rounded,
                            color: Color(0xffFF8700),
                          ),
                          Text(
                            movie.voteAverage?.roundToDouble().toString() ?? '',
                            style: const TextStyle(
                              color: Color(0xffFF8700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 128,
                child: SizedBox(
                  width: 210,
                  child: Text(
                    movie.title ?? '',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        MovieDetailsPageContentInfo(
          movie: movie,
        ),
        const SizedBox(height: 24),
        const DetailsPageTabBar(),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
              left: 16,
              right: 16,
              top: 8,
            ),
            child: const CustomTapBarView(),
          ),
        ),
      ],
    );
  }
}

class MovieDetailsPageContentInfo extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsPageContentInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          MovieDetailsPageContentInfoItem(
            data: movie.releaseDate ?? '',
          ),
          const VerticalDivider(
            color: Color(0xff92929D),
          ),
          const MovieDetailsPageContentInfoItem(
            data: '148 minute',
            icon: Icons.watch_later_outlined,
          ),
          const VerticalDivider(
            color: Color(0xff92929D),
          ),
          MovieDetailsPageContentInfoItem(
            data: movie.originalLanguage?.toUpperCase() ?? '',
            icon: Icons.confirmation_num_outlined,
          ),
        ],
      ),
    );
  }
}

class MovieDetailsPageContentInfoItem extends StatelessWidget {
  final String data;
  final IconData icon;

  const MovieDetailsPageContentInfoItem({
    super.key,
    this.data = 'Error',
    this.icon = Icons.calendar_today_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: const Color(0xff92929D),
        ),
        const SizedBox(width: 8),
        Text(
          data,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff92929D),
          ),
        ),
      ],
    );
  }
}

class DetailsPageTabBar extends StatefulWidget {
  const DetailsPageTabBar({super.key, required});

  @override
  State<DetailsPageTabBar> createState() => _DetailsPageTabBarState();
}

class _DetailsPageTabBarState extends State<DetailsPageTabBar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(
      length: 3,
      vsync: this,
    );

    return TabBar(
      controller: tabController,
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
      tabs: const <Tab>[
        Tab(
          text: 'Description',
        ),
        Tab(
          text: 'Comment',
        ),
        Tab(
          text: 'Actors',
        ),
      ],
    );
  }
}

class CustomTapBarView extends StatelessWidget {
  const CustomTapBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTapBarViewReviews();
  }
}

class CustomTapBarViewReviews extends StatelessWidget {
  const CustomTapBarViewReviews({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> commentsList = List.generate(
      5,
      (index) => const MovieDetailsPageMovieCommentsItem(),
    );
    return Column(
      children: commentsList,
    );
  }
}

class MovieDetailsPageMovieCommentsItem extends StatelessWidget {
  const MovieDetailsPageMovieCommentsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Column(
          children: [
            SizedBox(
              height: 50,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '6.4',
              style: TextStyle(
                color: Color(0xff0296E5),
              ),
            ),
          ],
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ivan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 250,
              child: Text(
                'From DC Comics comes the Suicide Squad, an antihero team of incarcerated super villains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
