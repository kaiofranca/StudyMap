import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
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
            secondaryContainer: Color(0xFF00EEFC),
            onSecondaryContainer: Color(0xFF00686F),
            tertiary: Color(0xFFFFB595),
            onTertiary: Color(0xFF571E00),
            tertiaryContainer: Color(0xFFEF6719),
            onTertiaryContainer: Color(0xFF4C1A00),
            error: Color(0xFFFFB4AB),
            onError: Color(0xFF690005),
            errorContainer: Color(0xFF93000A),
            onErrorContainer: Color(0xFFFFDAD6),
            surface: Color(0xFF111317),
            onSurface: Color(0xFFE2E2E7),
            surfaceContainerLowest: Color(0xFF0C0E12),
            surfaceContainerLow: Color(0xFF1A1C1F),
            surfaceContainer: Color(0xFF1E2023),
            surfaceContainerHigh: Color(0xFF282A2E),
            surfaceContainerHighest: Color(0xFF333539),
            onSurfaceVariant: Color(0xFFC1C6D7),
            outline: Color(0xFF8B90A0),
            outlineVariant: Color(0xFF414755),
            inverseSurface: Color(0xFFE2E2E7),
            onInverseSurface: Color(0xFF2E3034),
            inversePrimary: Color(0xFF005BC1),
            surfaceTint: Color(0xFFADC6FF),
          ),
          scaffoldBackgroundColor: const Color(0xFF111317),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
            displayLarge: GoogleFonts.spaceGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.64,
              color: const Color(0xFFE2E2E7),
            ),
            displayMedium: GoogleFonts.spaceGrotesk(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.3,
              color: const Color(0xFFE2E2E7),
            ),
            bodyLarge: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              height: 1.6,
              color: const Color(0xFFE2E2E7),
            ),
            bodyMedium: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.6,
              color: const Color(0xFFE2E2E7),
            ),
            labelSmall: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.2,
              letterSpacing: 0.6,
              color: const Color(0xFFC1C6D7),
            ),
            labelMedium: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.0,
              color: const Color(0xFFE2E2E7),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF111317),
            foregroundColor: Color(0xFFE2E2E7),
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B8EFF),
              foregroundColor: const Color(0xFF002E69),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE2E2E7),
              minimumSize: const Size(double.infinity, 52),
              side: const BorderSide(color: Color(0x33FFFFFF), width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF1E2023),
            floatingLabelStyle: const TextStyle(color: Color(0xFFADC6FF)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF414755)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF414755)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFADC6FF), width: 2),
            ),
            labelStyle: const TextStyle(color: Color(0xFF8B90A0)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
          cardTheme: CardThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0x33FFFFFF), width: 1),
            ),
            color: const Color(0xFF1E2023),
            elevation: 0,
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
