import 'package:klikit/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://api-qa.shadowchef.co',
    cdnUrl: 'https://cdn-qa.shadowchef.co',
    segmentWriteKey: 'djROSUJqa21nc2dKUUJTOUJGaWU3ckFsZHIwM01nSGg=',
  );
  mainCommon(environmentVariables);
}
