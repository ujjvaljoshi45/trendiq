import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trendiq/common/theme.dart';
import 'package:trendiq/common/routes.dart';
import 'package:trendiq/constants/user_singleton.dart';
import 'package:trendiq/services/api/api_service.dart';
import 'package:trendiq/services/connectivity_service.dart';
import 'package:trendiq/services/log_service.dart';
import 'package:trendiq/services/theme/theme_bloc.dart';
import 'package:trendiq/services/theme/theme_state.dart';
import 'package:trendiq/views/auth_view/bloc/auth_bloc.dart';
import 'package:trendiq/views/cart/bloc/cart_bloc.dart';
import 'package:trendiq/views/category_view/bloc/category_bloc.dart';
import 'package:trendiq/views/home/bloc/home_bloc.dart';
import 'package:trendiq/views/search_view/bloc/search_bloc.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_bloc.dart';
import 'package:trendiq/services/shared_pref_service.dart' as pref;

import 'firebase_options.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initServices();
      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeBloc()),
            BlocProvider(create: (_) => AuthBloc()),
            BlocProvider(create: (_) => HomeBloc()),
            BlocProvider(create: (_) => TrendingProductsBloc()),
            BlocProvider(create: (_) => CategoryBloc()),
            BlocProvider(create: (_) => SearchBloc()),
            BlocProvider(create: (_) => CartBloc()),
          ],
          child: MyApp(),
        ),
      );
    },
    (error, stack) {
      LogService().logError("Error", error, stack);
    },
  );
}

Future<void> initServices() async {
  await pref.Storage().init();
  ConnectivityService().init();
  ApiService().initDio();
  LogService().init();
  UserSingleton().getUser();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: Routes().navigatorKey,
              onGenerateRoute: Routes().onGenerateRoute,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: state.themeMode,
            ),
          ),
        );
      },
    );
  }
}
