import 'dart:developer';

import 'package:dio/dio.dart';
import '../config/app_config.dart';

/// Logging Interceptor til Dio
/// 
/// Logger alle API requests og responses når enableApiLogging er true.
/// Hjælper med debugging under udvikling.
/// 
/// Features:
/// - Logger request method, URL, headers, og body
/// - Logger response status, data, og timing
/// - Logger fejl med detaljer
/// - Pretty printing for bedre læsbarhed
/// - Conditional logging baseret på environment
class LoggingInterceptor extends Interceptor {
  final bool enableLogging;

  LoggingInterceptor({bool? enableLogging})
      : enableLogging = enableLogging ?? AppConfig.instance.enableApiLogging;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enableLogging) {
      log('╔═══════════════════════════════════════════════════════════════');
      log('║ 🚀 REQUEST');
      log('╠═══════════════════════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═');
      log('║ Method: ${options.method}');
      log('║ URL: ${options.uri}');
      
      if (options.headers.isNotEmpty) {
        log('║ Headers:');
        options.headers.forEach((key, value) {
          log('║   $key: $value');
        });
      }
      
      if (options.data != null) {
        log('║ Body: ${options.data}');
      }
      
      if (options.queryParameters.isNotEmpty) {
        log('║ Query Parameters: ${options.queryParameters}');
      }
      
      log('╚═══════════════════════════════════════════════════════════════\n');
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enableLogging) {
      log('╔═══════════════════════════════════════════════════════════════');
      log('║ ✅ RESPONSE');
      log('╠═══════════════════════════════════════════════════════════════');
      log('║ Status: ${response.statusCode}');
      log('║ URL: ${response.requestOptions.uri}');
      log('║ Data: ${response.data}');
      log('╚═══════════════════════════════════════════════════════════════\n');
    }
    
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enableLogging) {
      log('╔═══════════════════════════════════════════════════════════════');
      log('║ ❌ ERROR');
      log('╠═══════════════════════════════════════════════════════════════');
      log('║ Type: ${err.type}');
      log('║ URL: ${err.requestOptions.uri}');
      log('║ Status: ${err.response?.statusCode}');
      log('║ Message: ${err.message}');
      
      if (err.response?.data != null) {
        log('║ Response Data: ${err.response?.data}');
      }
      
      log('╚═══════════════════════════════════════════════════════════════\n');
    }
    
    super.onError(err, handler);
  }
}

/// Auth Interceptor til Dio
/// 
/// Tilføjer automatisk authorization headers til alle requests.
/// Kan nemt udvides til at håndtere token refresh.
/// 
/// Usage:
/// ```dart
/// dio.interceptors.add(AuthInterceptor(tokenProvider: () => getToken()));
/// ```
class AuthInterceptor extends Interceptor {
  /// Callback der returnerer current auth token
  final Future<String?> Function() tokenProvider;

  AuthInterceptor({required this.tokenProvider});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Hent token fra token provider
    final token = await tokenProvider();
    
    if (token != null && token.isNotEmpty) {
      // Tilføj Bearer token til Authorization header
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Remember: Implementer token refresh logic her hvis nødvendigt
    // Hvis 401 Unauthorized, prøv at refresh token og retry request
    
    if (err.response?.statusCode == 401) {
      // Log user out eller refresh token
      log('⚠️ Unauthorized request - token might be expired');
    }
    
    super.onError(err, handler);
  }
}

/// Retry Interceptor
/// 
/// Prøver automatisk at gentage failed requests et antal gange.
/// Nyttigt ved midlertidige netværksfejl.
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra = err.requestOptions.extra;
    final retries = extra['retries'] ?? 0;

    // Check om vi skal retry
    if (retries < maxRetries && _shouldRetry(err)) {
      log('🔄 Retrying request... (attempt ${retries + 1}/$maxRetries)');
      
      // Vent før retry
      await Future.delayed(retryDelay);
      
      // Opdater retry count
      err.requestOptions.extra['retries'] = retries + 1;
      
      // Retry request
      try {
        final response = await Dio().fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    }
    
    super.onError(err, handler);
  }

  /// Bestem om vi skal retry baseret på fejl type
  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}

