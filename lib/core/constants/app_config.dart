
class AppConfig {
  static const String BASE_URL = 'http://172.20.10.5:8000';

  static const String API_PATH = '$BASE_URL/api/';
  static const String STORAGE_PATH = '$BASE_URL/storage/';
  static const String STORAGE_IMAGE = STORAGE_PATH;
  static const String STORAGE_AVATAR = '${STORAGE_PATH}customers/';

  static const String URL_PAYMENT =
      'https://app.sandbox.midtrans.com/snap/v2/vtweb/';
}
