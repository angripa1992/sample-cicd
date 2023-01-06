/*

user mobile - (trait)
user email - (trait)
user type -  (trait -> title)

app version -  (context -> app -> version)
device OS -  (context -> device -> type)
device OS version -  (context -> device -> version)
device model -  (context -> device -> model)

location(city) - (context -> location -> city)
location(country) - (context -> location -> country)
location(lat) - (context -> location -> latitude)
location(lon) - (context -> location -> longitude)

*/

import '../app/app_preferences.dart';
import '../core/provider/device_information_provider.dart';

class SegmentParameters {
  final AppPreferences _appPreferences;
  final DeviceInfoProvider _deviceInfoProvider;

  SegmentParameters(this._appPreferences, this._deviceInfoProvider);
}
