// ignore_for_file: prefer_collection_literals, unnecessary_this

class City {
  List<CityList>? cityList;
  bool? result;
  String? reason;

  City({this.cityList, this.result, this.reason});

  City.fromJson(Map<String, dynamic> json) {
    if (json['city_list'] != null) {
      cityList = <CityList>[];
      json['city_list'].forEach((v) {
        cityList!.add(CityList.fromJson(v));
      });
    }
    result = json['result'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.cityList != null) {
      data['city_list'] = this.cityList!.map((v) => v.toJson()).toList();
    }
    data['result'] = this.result;
    data['reason'] = this.reason;
    return data;
  }
}

class CityList {
  String? id;
  String? name;
  String? stateId;
  String? isDeleted;

  CityList({this.id, this.name, this.stateId, this.isDeleted});

  CityList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    data['is_deleted'] = this.isDeleted;
    return data;
  }
}
