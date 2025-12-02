import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/transcription/transcription_page.dart';
import '../presentation/pages/detail/detail_page.dart';
import '../presentation/pages/settings/settings_page.dart';

/// 路由 Provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/transcription',
        name: 'transcription',
        builder: (context, state) {
          final language = state.extra as String?;
          return TranscriptionPage(languageCode: language);
        },
      ),
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailPage(transcriptionId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
