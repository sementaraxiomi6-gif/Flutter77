
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:food_store/resource/model/customer_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRemoteResource {
  final Dio _dio;

  ProfileRemoteResource(this._dio);

  // FETCH PROFILE
  Future<Either<String, CustomerModel>> fetchProfile() async {
    try {
      final response = await _dio.get('customer/my-profile');

      if (response.statusCode == 200) {
        final profile = CustomerModel.fromMap(
          Map<String, dynamic>.from(response.data['data']),
        );

        return Right(profile);
      }

      return Left('Failed to fetch profile');
    } on DioException catch (e) {
      final data = e.response?.data;

      return Left(
        data is Map
            ? data['message']?.toString() ?? e.message ?? 'Failed to fetch profile'
            : e.message ?? 'Failed to fetch profile',
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  // UPDATE PROFILE
  Future<Either<dynamic, String>> updateProfile({
    required String name,
    required String email,
    XFile? image,
    String? password,
    String? passwordConfirmation,
  }) async {
    try {
      final Map<String, dynamic> fields = {
        'name': name,
        'email': email,
      };

      if (image != null) {
        fields['image'] = MultipartFile.fromBytes(
          await image.readAsBytes(),
          filename: image.name,
        );
      }

      if (password != null && password.isNotEmpty) {
        fields['password'] = password;
        fields['password_confirmation'] = passwordConfirmation ?? '';
      }

      final formData = FormData.fromMap(fields);

      final response = await _dio.post(
        'customer/my-profile',
        data: formData,
      );

      if (response.statusCode == 200) {
        return Right(
          response.data['message']?.toString() ?? 'Update Profil Berhasil',
        );
      }

      return Left({
        'message': response.data['message']?.toString() ?? 'Update gagal',
      });
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
            ? data['message']?.toString() ?? 'Update profil gagal'
            : e.message ?? 'Update profil gagal',
      });
    } catch (e) {
      return Left({'message': e.toString()});
    }
  }
}
