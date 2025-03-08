import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/features/admin_Dashboard/testScreen.dart';
import 'package:eventure/features/events/notification_services.dart';
import 'package:eventure/features/events/presentation/blocs/book_btn/book_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/favorite_btn/favorite_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/save_btn/save_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/scroll/scroll_bloc.dart';
import 'package:eventure/features/events/presentation/pages/details_page.dart';
import 'package:eventure/features/events/presentation/pages/home_page.dart';
import 'package:eventure/features/splash/presentation/page/splash.dart';
import 'package:eventure/firebase_options.dart';
import 'package:eventure/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependency injection
  init();

  // Initialize notifications
  NotificationService.initialize();

  runApp(kIsWeb ? AdminApp() : const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Starts listening for notifications when the app runs
    SizeConfig().init(context);

    return ScreenUtilInit(
      // designSize: const Size(390, 844),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          create: (context) =>
              getIt<FavoriteBloc>()..add(FetchFavoriteEvents()),
          child: SplashScreen(), // HomePage(),
        ),
        routes: {
          '/home': (context) => BlocProvider(
                create: (context) =>
                    getIt<FavoriteBloc>()..add(FetchFavoriteEvents()),
                child: HomePage(),
              ),
          '/details': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => getIt<FavoriteBtnBloc>()),
                  BlocProvider(create: (context) => getIt<SaveBtnBloc>()),
                  BlocProvider(create: (context) => getIt<BookBtnBloc>()),
                  BlocProvider(create: (context) => getIt<ScrollBloc>()),
                ],
                child: DetailsPage(),
              )
        },
      ),
    );
  }
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AdminDashboard(),
    );
  }
}
