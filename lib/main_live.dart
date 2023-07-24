import 'package:klikit/app/enums.dart';
import 'package:klikit/env/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  // final environmentVariables = EnvironmentVariables(
  //   baseUrl: 'https://gateway-enterprise.klikit.io',
  //   cdnUrl: 'https://assets.klikit.io',
  //   segmentWriteKey: 'Sm10a3NTc2lnUjJVMXpBb05JalNJZk4wQjU1SWxyZWg=',
  // );
  mainCommon(Env.LIVE);
}