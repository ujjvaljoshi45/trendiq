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
import 'package:trendiq/services/api/api_service.dart';
import 'package:trendiq/services/connectivity_service.dart';
import 'package:trendiq/services/log_service.dart';
import 'package:trendiq/services/theme/theme_bloc.dart';
import 'package:trendiq/services/theme/theme_state.dart';
import 'package:trendiq/views/auth_view/bloc/auth_bloc.dart';
import 'package:trendiq/views/cart/bloc/cart_bloc.dart';
import 'package:trendiq/views/category_view/bloc/category_bloc.dart';
import 'package:trendiq/views/home/bloc/home_bloc.dart';
import 'package:trendiq/views/profile/address/bloc/address_bloc.dart';
import 'package:trendiq/views/profile/orders/bloc/order_bloc.dart';
import 'package:trendiq/views/search_view/bloc/search_bloc.dart';
import 'package:trendiq/views/trending_products/bloc/trending_products_bloc.dart';
import 'package:trendiq/services/storage_service.dart' as pref;
import 'package:trendiq/views/wishlist/bloc/wishlist_bloc.dart';

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
            BlocProvider(create: (_) => AddressBloc()),
            BlocProvider(create: (_) => WishlistBloc()),
            BlocProvider(create: (_) => OrderBloc()),
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
  await pref.StorageService().init();
  ConnectivityService().init();
  ApiService().initDio();
  LogService().init();
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
