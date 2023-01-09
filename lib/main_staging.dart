import 'package:klikit/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://api-qa.shadowchef.co',
    cdnUrl: 'https://cdn-qa.shadowchef.co',
    segmentWriteKey: 'alQxTlFDYkl3TklCS2NiTll2UlNmTUhDTGs2dmxoRDQ=',
  );
  mainCommon(environmentVariables);
}
