import 'package:klikit/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://gateway-enterprise.klikit.io',
    cdnUrl: 'https://assets.klikit.io',
    segmentWriteKey: 'djROSUJqa21nc2dKUUJTOUJGaWU3ckFsZHIwM01nSGg=',
  );
  mainCommon(environmentVariables);
}
