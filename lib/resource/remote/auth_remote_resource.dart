
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:food_store/resource/local/auth_local_resource.dart';
import 'package:food_store/resource/model/auth_response_model.dart';

class AuthRemoteResource {
  final Dio _dio;

  AuthRemoteResource(this._dio);

  // LOGIN
  Future<Either<String, AuthResponseModel>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        'customer/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = Map<String, dynamic>.from(response.data);

      final authResponse = AuthResponseModel.fromMap(data);

      final token = authResponse.token;

      if (token != null && token.isNotEmpty) {
        await AuthLocalResource.saveToken(token);
      }

      return Right(authResponse);
    } on DioException catch (e) {
      final data = e.response?.data;

      final message = data is Map
          ? data['message']?.toString()
          : null;

      return Left(message ?? 'Login gagal: ${e.message}');
    } catch (e) {
      return Left('Login gagal: $e');
    }
  }

  // REGISTER
  Future<Either<Map<String, dynamic>, String>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final response = await _dio.post(
        'customer/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final data = response.data;

      final message = data is Map
          ? data['message']?.toString()
          : null;

      return Right(message ?? 'Register berhasil');
    } on DioException catch (e) {
      final data = e.response?.data;

      if (e.response?.statusCode == 422 &&
          data is Map &&
          data['data'] is Map) {
        return Left(
          Map<String, dynamic>.from(data['data']),
        );
      }

      return Left({
        'message': data is Map
            ? data['message']?.toString() ?? 'Register gagal'
            : 'Register gagal: ${e.message}',
      });
    } catch (e) {
      return Left({
        'message': 'Register gagal: $e',
      });
    }
  }

  // LOGOUT
  Future<String> logout() async {
    try {
      final token = await AuthLocalResource.getToken();

      if (token == null || token.isEmpty) {
        return 'Token tidak ditemukan';
      }

      final response = await _dio.post(
        'customer/logout',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data['message']?.toString() ??
          'Logout berhasil';
    } on DioException catch (e) {
      final data = e.response?.data;

      return data is Map
          ? data['message']?.toString() ??
              'Logout server gagal: ${e.message}'
          : 'Logout server gagal: ${e.message}';
    } finally {
      await AuthLocalResource.deleteToken();
    }
  }
}
