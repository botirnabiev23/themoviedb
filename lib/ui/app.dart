import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:themoviedb/domain/bloc/movies_bloc.dart';
import 'package:themoviedb/domain/bloc/upcoming_bloc.dart';
import 'package:themoviedb/ui/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Connectivity connectivity = Connectivity();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        noAppBar: true,
        systemNavBarStyle: FlexSystemNavBarStyle.transparent,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<UpcomingBloc>(
            create: (context) => UpcomingBloc()
              ..add(
                const UpcomingLoadEvent(),
              ),
          ),
          BlocProvider<MoviesBloc>(
            create: (context) => MoviesBloc()
              ..add(
                const MoviesLoadEvent(),
              ),
          ),
        ],
        child: StreamBuilder(
          stream: connectivity.onConnectivityChanged,
          builder: (context, snapshot) {
            if (snapshot.data?[0] == ConnectivityResult.none) {
              return const MaterialApp(
                home: Scaffold(),
              );
            } else {
              return const MyAppContent();
             }
          },
        ),
      ),
    );
  }
}

class MyAppContent extends StatelessWidget {
  const MyAppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlutterSplashScreen.scale(
        backgroundColor: const Color(0xff242A32),
        childWidget: Image.asset('assets/images/splash.png'),
        nextScreen: const HomePage(),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff242A32),
      ),
    );
  }
}
