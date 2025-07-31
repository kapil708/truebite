import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:go_router/go_router.dart';

import 'core/route/app_router.dart';
import 'core/theme/theme.dart';
import 'core/theme/util.dart';
import 'di/environment.dart';
import 'di/service_locator.dart' as di;
import 'presentation/app/viewmodel/app_bloc.dart';

void main() async {
  // Base setup
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Load environment values
  await dotenv.load(fileName: ".env");

  // Gemini setup
  Gemini.init(apiKey: Environment.geminiApiKey);

  // Dependency injection
  await di.setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Do not put AppRouter().router inside build method -> it will start the from initial route '/' on "Hot Reload"
  final GoRouter _router = AppRouter().router;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Theme and typo setup
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Roboto", "Poppins");
    MaterialTheme theme = MaterialTheme(textTheme);

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
            theme: theme.light(),
            darkTheme: theme.dark(),
            // theme: brightness == Brightness.light ? theme.light() : theme.dark(),
            // themeMode: ThemeMode.light,
            // themeMode: state.selectedThemeMode.value,
            // theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
            // darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),

            /// Localization
            // locale: state.selectedLanguage.value,
            // localizationsDelegates: AppLocalizations.localizationsDelegates,
            // supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );

    // return MaterialApp.router(
    //   debugShowCheckedModeBanner: false,
    //   title: "Food Ai",
    //   routerConfig: _router,
    //
    //   /// Theming
    //   themeMode: ThemeMode.light,
    //   theme: theme.light(),
    //   darkTheme: theme.dark(),
    //
    //   // theme: brightness == Brightness.light ? theme.light() : theme.dark(),
    //   // themeMode: ThemeMode.light,
    //   // themeMode: state.selectedThemeMode.value,
    //   // theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
    //   // darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
    //
    //   /// Localization
    //   // locale: state.selectedLanguage.value,
    //   // localizationsDelegates: AppLocalizations.localizationsDelegates,
    //   // supportedLocales: AppLocalizations.supportedLocales,
    // );
  }
}
