
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'package:food_store/app_router.dart';
import 'package:food_store/core/constants/app_config.dart';
import 'package:food_store/core/utils/auth_interceptor.dart';

import 'package:food_store/bloc/auth/auth_bloc.dart';
import 'package:food_store/bloc/profile/profile_bloc.dart';

import 'package:food_store/resource/remote/auth_remote_resource.dart';
import 'package:food_store/resource/remote/profile_remote_resource.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Dio untuk komunikasi dengan Laravel API.
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.API_PATH,
    ),
  );

  // Inisialisasi resource autentikasi.
  final authRemoteResource = AuthRemoteResource(dio);

  // Inisialisasi AuthBloc.
  final authBloc = AuthBloc(authRemoteResource);

  // Pasang interceptor dengan instance AuthBloc yang sama.
  dio.interceptors.add(AuthInterceptor(authBloc));

  // Inisialisasi resource profil.
  final profileRemoteResource = ProfileRemoteResource(dio);

  // Inisialisasi router.
  final appRouter = AppRouter(authBloc);

  // Jalankan pemeriksaan status login.
  authBloc.add(const AuthEvent.checkLoginStatus());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(
          value: authBloc,
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(profileRemoteResource),
        ),
      ],
      child: MyApp(
        appRouter: appRouter,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Food Store',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade100,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter.router,
    );
  }
}
