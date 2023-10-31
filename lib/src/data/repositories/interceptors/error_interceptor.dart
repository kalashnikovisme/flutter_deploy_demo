import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this.errorHandler);

  final Function(String s) errorHandler;

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.unknown) {
      final errorMessage = errorHandler(err.response?.statusCode.toString() ??
          'Something went wrong with your internet connection \n Please, find Wi-Fi or mobile connection to continue');
      errorHandler(errorMessage);
    }
    handler.next(err);
  }
}
