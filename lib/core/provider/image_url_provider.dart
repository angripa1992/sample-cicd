import '../../app/di.dart';
import '../../env/environment_variables.dart';

class ImageUrlProvider {
  static final _envVariables = getIt.get<EnvironmentVariables>();

  static String getUrl(String path) {
    return '${_envVariables.cdnUrl}$path';
  }
}
