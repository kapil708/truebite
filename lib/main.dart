import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:food_ai/environment.dart';
import 'package:go_router/go_router.dart';

import 'core/route/app_router.dart';
import 'injection_container.dart' as di;
import 'l10n/app_localizations.dart';
import 'presentation/bloc/app/app_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: Environment.apiKey);

  await di.setUp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Do not put AppRouter().router inside build method -> it will start the from initial route '/' on "Hot Reload"
  final GoRouter _router = AppRouter().router;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) => AppBloc()..add(OnAppInit()),
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: "Food Ai",
            routerConfig: _router,

            /// Theming
            themeMode: ThemeMode.light,
            // themeMode: state.selectedThemeMode.value,
            // theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
            // darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),

            /// Localization
            locale: state.selectedLanguage.value,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
