import 'package:dio/dio.dart';
void main() {
  final dio = Dio(BaseOptions(baseUrl: 'https://resume-pilot-lc1i.onrender.com/api/v1'));
  dio.interceptors.add(InterceptorsWrapper(onRequest:(options, handler) {
    print('ACTUAL DIO URI: ${options.uri}');
    handler.reject(DioException(requestOptions: options));
  }));
  
  dio.get('auth/login').catchError((e){});
}
