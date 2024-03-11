import '../configs/app_config.dart';

class ServerEnv {
  ///base url
  static String baseUrl = '${appConfig.configs['base']['url']}/wp-json';

  //auth endpoints
  //static String loginUrl = "$baseUrl/login";
}
