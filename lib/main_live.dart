import 'package:klikit/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://api.dev.shadowchef.co',
    cdnUrl: 'https://assets.klikit.io',
  );
  mainCommon(environmentVariables);
}