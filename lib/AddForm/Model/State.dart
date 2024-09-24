class States {
  List<StatesList>? statesList;
  bool? result;
  String? reason;

  States({this.statesList, this.result, this.reason});

  States.fromJson(Map<String, dynamic> json) {
    if (json['states_list'] != null) {
      statesList = <StatesList>[];
      json['states_list'].forEach((v) {
        statesList!.add(new StatesList.fromJson(v));
      });
    }
    result = json['result'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statesList != null) {
      data['states_list'] = this.statesList!.map((v) => v.toJson()).toList();
    }
    data['result'] = this.result;
    data['reason'] = this.reason;
    return data;
  }
}

class StatesList {
  String? id;
  String? name;
  String? countryId;
  String? isDeleted;

  StatesList({this.id, this.name, this.countryId, this.isDeleted});

  StatesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    data['is_deleted'] = this.isDeleted;
    return data;
  }
}
