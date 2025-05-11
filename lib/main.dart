import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trendiq/common/theme.dart';
import 'package:trendiq/common/routes.dart';
import 'package:trendiq/services/api/api_service.dart';
import 'package:trendiq/services/connectivity_service.dart';
import 'package:trendiq/services/log_service.dart';
import 'package:trendiq/services/theme/theme_bloc.dart';
import 'package:trendiq/services/theme/theme_state.dart';
import 'package:trendiq/services/toast_service.dart';
import 'package:trendiq/views/category_view/bloc/category_bloc.dart';
import 'package:trendiq/views/home/bloc/home_bloc.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_bloc.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initServices();
      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeBloc()),
            BlocProvider(create: (_) => HomeBloc()),
            BlocProvider(create: (_) => TrendingProductsBloc()),
            BlocProvider(create: (_) => CategoryBloc()),
          ],
          child: MyApp(),
        ),
      );
    },
    (error, stack) {
      try {
        Navigator.of(Routes().navigatorKey.currentContext!).pushNamed("/");
      } catch (e) {
        ToastService().showToast(
          "Please Re-start App.",
          isError: true,
          seconds: 1000,
        );
      }
    },
  );
}

Future<void> initServices() async {
  ConnectivityService().init();
  ApiService().initDio();
  LogService().init();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.ensureScreenSizeAndInit(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return ToastificationWrapper(
          child: MaterialApp(
            navigatorKey: Routes().navigatorKey,
            onGenerateRoute: Routes().onGenerateRoute,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state.themeMode,
          ),
        );
      },
    );
  }
}
