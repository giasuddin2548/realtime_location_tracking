class DataModel {
  DataModel({
      this.id, 
      this.userId, 
      this.latitude, 
      this.longitude,});

  DataModel.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
  String? id;
  String? userId;
  String? latitude;
  String? longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }

}