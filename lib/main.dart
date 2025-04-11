import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trendiq/common/colors.dart';
import 'package:trendiq/common/routes.dart';
import 'package:trendiq/services/theme/theme_bloc.dart';
import 'package:trendiq/services/theme/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ThemeBloc())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          onGenerateRoute: Routes().onGenerateRoute,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state.themeMode,
        );
      },
    );
  }
}
