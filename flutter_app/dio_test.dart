import 'package:dio/dio.dart';

void main() {
  final dio = Dio(
      BaseOptions(baseUrl: 'https://resume-pilot-lc1i.onrender.com/api/v1'));
  print(dio.options.baseUrl);

  // Create a fake request to see the final URI
  var uri = dio.options.baseUrl + '/auth/login';
  // Let's actually test how Dio handles it internally via a RequestOptions
  var req = RequestOptions(
      path: '/auth/login',
      baseUrl: 'https://resume-pilot-lc1i.onrender.com/api/v1');
  print('Request 1 path: ${req.uri}');
}
