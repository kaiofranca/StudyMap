import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/data/auth_repository_impl.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/places/data/place_repository_impl.dart';
import '../features/places/presentation/places_controller.dart';
import '../features/subjects/data/subject_repository_impl.dart';
import '../features/subjects/presentation/subjects_controller.dart';
import '../features/session/data/session_repository_impl.dart';
import '../features/session/presentation/session_controller.dart';
import '../features/stats/presentation/stats_controller.dart';
import '../features/main/presentation/main_shell.dart';

class StudyMapApp extends StatelessWidget {
  const StudyMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthRepositoryImpl()),
        ChangeNotifierProvider(
          create: (context) => AuthController(context.read<AuthRepositoryImpl>()),
        ),
        // Repositories
        ProxyProvider<AuthController, PlaceRepositoryImpl?>(
          update: (_, auth, __) =>
              auth.isAuthenticated ? PlaceRepositoryImpl(auth.user!.id) : null,
        ),
        ProxyProvider<AuthController, SubjectRepositoryImpl?>(
          update: (_, auth, __) =>
              auth.isAuthenticated ? SubjectRepositoryImpl(auth.user!.id) : null,
        ),
        ProxyProvider<AuthController, SessionRepositoryImpl?>(
          update: (_, auth, __) =>
              auth.isAuthenticated ? SessionRepositoryImpl(auth.user!.id) : null,
        ),
        // Controllers
        ChangeNotifierProxyProvider<PlaceRepositoryImpl?, PlacesController>(
          create: (context) => PlacesController(PlaceRepositoryImpl('')),
          update: (context, repo, previous) =>
              previous!..updateRepository(repo),
        ),
        ChangeNotifierProxyProvider<SubjectRepositoryImpl?, SubjectsController>(
          create: (context) => SubjectsController(SubjectRepositoryImpl('')),
          update: (context, repo, previous) =>
              previous!..updateRepository(repo),
        ),
        ChangeNotifierProxyProvider<SessionRepositoryImpl?, SessionController>(
          create: (context) => SessionController(SessionRepositoryImpl('')),
          update: (context, repo, previous) =>
              previous!..updateRepository(repo),
        ),
        ChangeNotifierProxyProvider2<SessionRepositoryImpl?, PlaceRepositoryImpl?, StatsController>(
          create: (context) => StatsController(SessionRepositoryImpl(''), PlaceRepositoryImpl('')),
          update: (context, sessionRepo, placeRepo, previous) {
            if (sessionRepo != null && placeRepo != null) {
              return StatsController(sessionRepo, placeRepo);
            }
            return previous!;
          },
        ),
      ],
      child: MaterialApp(
        title: 'StudyMap',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFADC6FF),
            onPrimary: Color(0xFF002E69),
            primaryContainer: Color(0xFF4B8EFF),
            onPrimaryContainer: Color(0xFF00285C),
            secondary: Color(0xFFD3FBFF),
            onSecondary: Color(0xFF00363A),
            surface: Color(0xFF111317),
            onSurface: Color(0xFFE2E2E7),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
          ),
          scaffoldBackgroundColor: const Color(0xFF111317),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF111317),
            foregroundColor: Color(0xFFE2E2E7),
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: const Color(0xFF121212),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    if (authController.isAuthenticated) {
      return const MainNavigationShell();
    } else {
      return const LoginScreen();
    }
  }
}
