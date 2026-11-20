
import 'package:dio/dio.dart';
import 'package:food_store/bloc/auth/auth_bloc.dart';
import 'package:food_store/resource/local/auth_local_resource.dart';

class AuthInterceptor extends Interceptor {
  final AuthBloc authBloc;

  AuthInterceptor(this.authBloc);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await AuthLocalResource.getToken();

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final hasAuthToken =
        err.requestOptions.headers['Authorization'] != null;

    final isLogoutRequest =
        err.requestOptions.path.contains('customer/logout');

    if (statusCode == 401 && hasAuthToken && !isLogoutRequest) {
      await AuthLocalResource.deleteToken();

      authBloc.add(
        const AuthEvent.logoutRequested(),
      );
    }

    handler.next(err);
  }
}
