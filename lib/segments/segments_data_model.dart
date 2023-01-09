class SegmentData {
  String? userId;
  String? event;
  String? name;
  Map<String,dynamic>? properties;
  SegmentTraits? traits;
  SegmentContext? context;
  String? timestamp;

  SegmentData({
    this.userId,
    this.event,
    this.name,
    this.properties,
    this.traits,
    this.context,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    if (traits != null) {
      data['traits'] = traits!.toJson();
    }
    if (context != null) {
      data['context'] = context!.toJson();
    }
    if (event != null) {
      data['event'] = event;
    }
    if (name != null) {
      data['name'] = name;
    }
    if (properties != null) {
      data['properties'] = properties;
    }
    data['timestamp'] = timestamp;
    return data;
  }
}

class SegmentContext {
  SegmentApp? app;
  SegmentDevice? device;
  SegmentLocation? location;
  SegmentTraits? traits;

  SegmentContext({this.app, this.device, this.location, this.traits});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (app != null) {
      data['app'] = app!.toJson();
    }
    if (device != null) {
      data['device'] = device!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (traits != null) {
      data['traits'] = traits!.toJson();
    }
    return data;
  }
}

class SegmentApp {
  String? version;

  SegmentApp({this.version});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    return data;
  }
}

class SegmentDevice {
  String? type;
  String? version;
  String? model;

  SegmentDevice({this.type, this.version, this.model});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['version'] = version;
    data['model'] = model;
    return data;
  }
}

class SegmentLocation {
  String? city;
  String? country;
  String? latitude;
  String? longitude;

  SegmentLocation({this.city, this.country, this.latitude, this.longitude});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['country'] = country;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class SegmentTraits {
  String? email;
  String? phone;
  String? title;

  SegmentTraits({this.email, this.phone, this.title});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phone'] = phone;
    data['title'] = title;
    return data;
  }
}
