import 'package:klikit/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://gateway-enterprise.klikit.io',
    cdnUrl: 'https://assets.klikit.io',
    segmentWriteKey: 'alQxTlFDYkl3TklCS2NiTll2UlNmTUhDTGs2dmxoRDQ=',
  );
  mainCommon(environmentVariables);
}