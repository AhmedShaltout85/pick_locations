class PickLocationModel {
  int? id;
  String? address;
  String? latitude;
  String? longitude;
  int? flag;
  String? realAddress;

  PickLocationModel(
      {this.id,
      this.address,
      this.latitude,
      this.longitude,
      this.flag,
      this.realAddress});

  PickLocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    flag = json['flag'];
    realAddress = json['real_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['flag'] = flag;
    data['real_address'] = realAddress;
    return data;
  }
}
