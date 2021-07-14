part of 'http.dart';

class ApiClient {
  ApiClient._(
    this._client,
  );

  final Dio _client;

  factory ApiClient.instance() {
    final options = BaseOptions(
      baseUrl: 'https://api.vk.com',
      connectTimeout: 10000,
      receiveTimeout: 40000,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
      },
    );
    final dio = Dio(options)
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          final accessTokenData = AccessTokenData.fromCache();

          options.queryParameters = {
            'access_token': accessTokenData.accessToken,
            'v': '5.131', // VK.com api version
            'lang': 'ru',
            ...options.queryParameters,
          };

          return handler.next(options);
        },
        onResponse: (response, handler) {
          final data = response.data;
          if (data != null && data is Map && data.containsKey('error')) {
            return handler.reject(DioError(
              requestOptions: response.requestOptions,
              error: ApiException.fromJson(data['error']),
              type: DioErrorType.other,
            ));
          }

          return handler.next(response);
        },
      ));

    if (kDebugMode) {
      dio.interceptors.add(CustomDioInterceptor(
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
    }

    return ApiClient._(dio);
  }

  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _client.get(
        url,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response.data['response'];
    } catch (e) {
      rethrow;
    }
  }
}
