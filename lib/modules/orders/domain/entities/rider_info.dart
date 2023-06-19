class RiderInfo {
  String? name;
  String? email;
  String? phone;
  String? photoUrl;
  Coordinates? coordinates;
  String? licensePlate;

  RiderInfo(
      {this.name,
        this.email,
        this.phone,
        this.photoUrl,
        this.coordinates,
        this.licensePlate});

  RiderInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    photoUrl = json['photo_url'];
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    licensePlate = json['license_plate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['photo_url'] = photoUrl;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.toJson();
    }
    data['license_plate'] = licensePlate;
    return data;
  }
}

class Coordinates {
  num? latitude;
  num? longitude;

  Coordinates({this.latitude, this.longitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
