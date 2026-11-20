
import 'package:flutter_test/flutter_test.dart';
import 'package:food_store/core/utils/error_handle.dart';

void main() {
  test('parseErrors mengambil pesan error pertama', () {
    final errors = {
      'email': ['Email sudah digunakan'],
      'password': [
        'Password terlalu pendek',
        'Harus mengandung angka',
      ],
    };

    final result = ErrorHandler.parseErrors(errors);

    expect(result, {
      'email': 'Email sudah digunakan',
      'password': 'Password terlalu pendek',
    });
  });
}
