import 'package:themoviedb_example/configuration/configuration.dart';

class ImageDownloader {
  static String imageUrl(String path) => Configuration.imageUrl + path;
}
