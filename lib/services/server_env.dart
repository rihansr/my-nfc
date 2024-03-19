import '../configs/app_config.dart';

class ServerEnv {
  ///base url
  static String baseUrl = '${appConfig.configs['base']['url']}/wp-json';

  // Unsplash Endpoints
  static String unsplashUrl = '${appConfig.configs['unsplash']['base_url']}';
  static String searchPhotos = '$unsplashUrl/search/photos';

  // Other
  static String placeholderImage =
      "https://via.placeholder.com/150/C9C9C9/FFFFFF/?text=Loading...";
}
