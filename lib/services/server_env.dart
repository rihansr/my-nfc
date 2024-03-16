import '../configs/app_config.dart';

class ServerEnv {
  ///base url
  static String baseUrl = '${appConfig.configs['base']['url']}/wp-json';

  // Unsplash Endpoints
  static String unsplashUrl = '${appConfig.configs['unsplash']['base_url']}';
  static String searchPhotos = '$unsplashUrl/search/photos';
}
