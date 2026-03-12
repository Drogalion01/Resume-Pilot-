import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(
      BaseOptions(baseUrl: 'https://resume-pilot-lc1i.onrender.com/api/v1'));
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  try {
    var res = await dio.post('/auth/register', data: {
      'full_name': 'T',
      'email': 't5@example.com',
      'password': 'Password123'
    });
    print(res.data);
  } catch (e) {
    if (e is DioException) {
      print(e.response?.statusCode);
      print(e.response?.data);
      print(e.requestOptions.uri);
    }
  }
}
