import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio_http_cache/dio_http_cache.dart' as dio;
import 'package:http/http.dart' as http;
import '../shared/strings.dart';
import '../shared/styles.dart';
import '../utils/debug.dart';
import '../utils/encryptor.dart';

final api = Api.function;

enum Method { get, post, put, delete }

enum InvokeType { http, dio, multipart, download }

class Api {
  static Api get function => Api._();
  Api._();

  Future<Response> invoke({
    InvokeType? via,
    required String baseUrl,
    String? endpoint,
    var path,
    Method method = Method.get,
    Map<String, String>? headers,
    Map<String, String>? additionalHeaders,
    Map<String, dynamic>? queryParams,
    var body,
    Duration timeout = const Duration(seconds: 30),
    String? contentType,
    bool contentTypeSupported = false,
    String? token,
    String? authSecret,
    dynamic id,
    bool enableEncoding = true,
    bool justifyResponse = true,
    bool showErrorMessage = true,
    Encoding? encoding,
    bool enableCaching = false,
    String? cachePrimaryKey,
    String? cacheSubKey,
    Duration? cacheDuration,
    bool chacheForceRefresh = false,
    Function(int)? onProgress,
  }) async {
    via ??= (() {
      if (enableCaching ||
          chacheForceRefresh ||
          (cacheDuration ?? cachePrimaryKey ?? cacheSubKey) != null) {
        return InvokeType.dio;
      } else {
        return InvokeType.http;
      }
    }());

    endpoint = _buildEndpoint(
      baseUrl: baseUrl,
      endpoint: endpoint,
      id: id,
      query: via == InvokeType.http ? queryParams : null,
    );

    headers ??= _buildHeaders(
      token: token,
      authSecret: authSecret,
      contentType: contentType,
      contentTypeSupported: contentTypeSupported ? true : contentType != null,
    )..addAll(additionalHeaders ?? {});

    body = enableEncoding && via != InvokeType.multipart
        ? body == null
            ? null
            : jsonEncode(body)
        : body;

    encoding ??= enableEncoding ? utf8 : null;

    Response response = await _exceptionHandler(
          (() async {
            switch (via) {
              case InvokeType.dio:
              case InvokeType.multipart:
              case InvokeType.download:
                dio.BaseOptions baseOptions = dio.BaseOptions(
                  method: method.name,
                  baseUrl: baseUrl,
                  connectTimeout: timeout.inMilliseconds,
                  headers: headers,
                  queryParameters: queryParams,
                  validateStatus: (status) => true,
                );

                final dio.LogInterceptor logInterceptor = dio.LogInterceptor(
                  request: false,
                  requestHeader: false,
                  responseHeader: false,
                  error: false,
                  logPrint: (s) => {},
                );

                int progress = -1;

                dio.Dio dioClient = dio.Dio(
                  (() {
                    switch (via) {
                      case InvokeType.dio:
                        return baseOptions.copyWith(
                          sendTimeout: timeout.inMilliseconds,
                          receiveTimeout: timeout.inMilliseconds,
                        );
                      case InvokeType.download:
                        return baseOptions.copyWith(
                          responseType: dio.ResponseType.bytes,
                          followRedirects: false,
                        );
                      default:
                        return baseOptions;
                    }
                  }()),
                )..interceptors.addAll([
                    if (enableCaching)
                      dio.DioCacheManager(
                        dio.CacheConfig(
                          baseUrl: baseUrl,
                          defaultRequestMethod: method.name,
                        ),
                      ).interceptor,
                    logInterceptor,
                  ]);

                return await dioClient
                    .request(
                      endpoint!,
                      data: via == InvokeType.multipart
                          ? dio.FormData.fromMap(body as Map<String, dynamic>)
                          : body,
                      options: enableCaching
                          ? dio.buildCacheOptions(
                              cacheDuration ?? const Duration(days: 1),
                              primaryKey: cachePrimaryKey ?? endpoint,
                              subKey: cacheSubKey ?? queryParams?.toString(),
                              forceRefresh: chacheForceRefresh,
                            )
                          : null,
                      onSendProgress: (received, total) {
                        int newPercentage =
                            total != -1 ? (received / total * 100).toInt() : 0;
                        if (progress != newPercentage) {
                          progress = newPercentage;
                          onProgress?.call(progress);
                        }
                      },
                      onReceiveProgress: (received, total) {
                        int newPercentage =
                            total != -1 ? (received / total * 100).toInt() : 0;
                        if (progress != newPercentage) {
                          progress = newPercentage;
                          onProgress?.call(progress);
                        }
                      },
                    )
                    .onError((error, stackTrace) => throw (error.toString()))
                    .timeout(
                      timeout,
                      onTimeout: () => throw TimeoutException(null),
                    )
                    .then(
                      (response) => Response(
                        statusCode: response.statusCode ?? 404,
                        data: response.data,
                      ),
                    );
              case InvokeType.http:
              default:
                http.Client client = http.Client();
                switch (method) {
                  case Method.post:
                    return await client
                        .post(Uri.parse(endpoint!),
                            headers: headers, body: body, encoding: encoding)
                        .timeout(
                          timeout,
                          onTimeout: () => throw TimeoutException(null),
                        )
                        .then(
                          (response) => Response(
                            statusCode: response.statusCode,
                            data: jsonDecode(response.body),
                          ),
                        );
                  case Method.put:
                    return await client
                        .put(Uri.parse(endpoint!),
                            headers: headers, body: body, encoding: encoding)
                        .timeout(
                          timeout,
                          onTimeout: () => throw TimeoutException(null),
                        )
                        .then(
                          (response) => Response(
                            statusCode: response.statusCode,
                            data: jsonDecode(response.body),
                          ),
                        );
                  case Method.delete:
                    return await client
                        .delete(Uri.parse(endpoint!),
                            headers: headers, body: body, encoding: encoding)
                        .timeout(
                          timeout,
                          onTimeout: () => throw TimeoutException(null),
                        )
                        .then(
                          (response) => Response(
                            statusCode: response.statusCode,
                            data: jsonDecode(response.body),
                          ),
                        );
                  default:
                    return await client
                        .get(Uri.parse(endpoint!), headers: headers)
                        .timeout(
                          timeout,
                          onTimeout: () => throw TimeoutException(null),
                        )
                        .then(
                          (response) => Response(
                            statusCode: response.statusCode,
                            data: jsonDecode(response.body),
                          ),
                        );
                }
            }
          })(),
          showErrorMessage,
        ) ??
        Response();

    return justifyResponse
        ? _justifyResponse(response,
            tag: endpoint, showMessage: showErrorMessage)
        : response;
  }

  String _buildEndpoint(
          {required String baseUrl,
          String? endpoint,
          var id,
          Map<String, dynamic>? query}) =>
      '${(endpoint?.isNotEmpty ?? false) ? '$baseUrl/$endpoint' : baseUrl}'
      '${id != null ? '/$id' : ''}'
      '${(query?.isNotEmpty ?? false) ? '?${query!.entries.map((e) => e.value == null ? '' : '${e.key}=${e.value}').join('&')}' : ''}';

  Map<String, String> _buildHeaders({
    String? token,
    String? authSecret,
    String? contentType,
    bool contentTypeSupported = false,
  }) =>
      {
        HttpHeaders.acceptHeader: 'application/json',
        if (contentTypeSupported)
          HttpHeaders.contentTypeHeader:
              contentType ?? dio.Headers.jsonContentType,
        if (authSecret != null) 'AuthSecret': decryptor(authSecret),
        if (token != null) HttpHeaders.authorizationHeader: "Bearer $token",
      };

  String basicAuthGenerator(
          {required String username, required String password}) =>
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Future<dynamic>? _exceptionHandler(Future function,
      [showMessage = true]) async {
    try {
      return await function;
    } on SocketException {
      _showErrorMessage(
        string.networkNotAvailable,
        logOnly: !showMessage,
        tag: "Socket Exception",
      );
    } on TimeoutException {
      _showErrorMessage(
        string.requestTimeout,
        logOnly: !showMessage,
        tag: "Timeout Exception",
      );
    } catch (e) {
      _showErrorMessage(
        e.toString(),
        logOnly: !showMessage,
        tag: "Exception",
      );
    }
    return null;
  }

  Response _justifyResponse(
    Response response, {
    String tag = "API",
    bool showMessage = true,
  }) {
    if ((response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202 ||
        response.statusCode == 409)) {
      debug.print(response.data, tag: tag);
      return response.copyWith(
        message: (response.data is Map?) ? (response.data?['message']) : null,
      );
    } else if (response.statusCode == 401) {
      _showErrorMessage(response, tag: tag, logOnly: !showMessage);
    } else {
      _showErrorMessage(response, tag: tag, logOnly: !showMessage);
    }
    return response.copyWith(data: null);
  }

  void _showErrorMessage(
    Object? response, {
    String? tag,
    String? orElse,
    bool logOnly = false,
  }) {
    if (response == null) return;
    response = (response is Response
            ? (response.data?.containsKey('error') ?? false)
                ? response.data['error'] is Map
                    ? response.data['error']['message']
                    : response.data['error']
                : response.data?.containsKey('message') ?? false
                    ? response.data['message']
                    : response.data?.containsKey('errors') ?? false
                        ? response.data['errors'].toString()
                        : null
            : response.toString()) ??
        orElse ??
        string.someErrorOccured;

    debug.print(response, tag: tag ?? "Error Log");

    if (logOnly) {
      return;
    } else {
      style.showToast(response.toString());
    }
  }
}

class Response {
  final int statusCode;
  final String? message;
  final dynamic data;

  Response({this.statusCode = 404, this.message, this.data});

  Response copyWith({
    int? statusCode,
    String? message,
    dynamic data,
  }) {
    return Response(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  String toString() =>
      'Status Code: $statusCode\nMessage: $message\nData: $data';
}
