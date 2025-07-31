import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'import_list.dart';
import 'route_names.dart';

// final LocalDataSource localDatSource = locator.get<LocalDataSource>();

class AppRouter {
  final GoRouter router = GoRouter(
    // errorBuilder: (context, state) => const Page404(),
    redirect: (context, state) async {
      /*if (state.location != '/' && state.location != '/login') {
        bool isLogin = await localDatSource.isLogin();
        return isLogin ? null : '/login';
      } else {
        return null;
      }*/

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: RouteName.splash,
        builder: (context, state) => BlocProvider(
          create: (_) => locator.get<SplashCubit>()..init(),
          child: const SplashPage(),
        ),
      ),
      GoRoute(
          path: '/home',
          name: RouteName.home,
          builder: (context, state) => BlocProvider(
                create: (context) => locator.get<HomeCubit>(),
                child: const HomePage(),
              ),
          routes: [
            GoRoute(
              path: 'foodDetail',
              name: RouteName.foodDetail,
              builder: (context, state) {
                List<dynamic> filePaths = [];
                if (state.uri.queryParameters['filePaths'] != null) {
                  filePaths = jsonDecode(state.uri.queryParameters['filePaths']!);
                }

                return BlocProvider(
                  create: (context) => locator.get<FoodDetailCubit>()..init(filePaths),
                  child: FoodDetailPage(),
                );
              },
            ),
          ]),
      // GoRoute(
      //   path: '/home',
      //   name: RouteName.home,
      //   builder: (context, state) => const HomePage(),
      //   routes: [
      //     GoRoute(
      //       path: 'foodDetail',
      //       name: RouteName.foodDetail,
      //       builder: (context, state) {
      //         List<dynamic> filePaths = [];
      //         if (state.uri.queryParameters['filePaths'] != null) {
      //           filePaths = jsonDecode(state.uri.queryParameters['filePaths']!);
      //         }
      //
      //         return FoodDetailPage(filePaths: filePaths);
      //       },
      //     ),
      //     GoRoute(
      //       path: 'foodDetailV2',
      //       name: RouteName.foodDetailV2,
      //       builder: (context, state) {
      //         List<dynamic> filePaths = [];
      //         if (state.uri.queryParameters['filePaths'] != null) {
      //           filePaths = jsonDecode(state.uri.queryParameters['filePaths']!);
      //         }
      //
      //         return FoodDetailJsonPage(filePaths: filePaths);
      //       },
      //     ),
      //     GoRoute(
      //       path: 'settings',
      //       name: RouteName.settings,
      //       builder: (context, state) => const SettingsPage(),
      //     ),
      //   ],
      // ),
    ],
  );
}
