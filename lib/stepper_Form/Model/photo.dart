// ignore_for_file: non_constant_identifier_names, camel_case_types

class form_Model {
  late int? id;
  late String F_Name;
  late String L_Name;
  late String Email;
  late String M_number;
  late String cityName;
  late String photoName;

  form_Model({
    this.id,
    required this.F_Name,
    required this.L_Name,
    required this.Email,
    required this.M_number,
    required this.cityName,
    required this.photoName,
  });

  form_Model.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    F_Name = map['firstName'];
    L_Name = map['lastName'];
    Email = map['email'];
    M_number = map['mNumber'];
    cityName = map['cityName'];
    photoName = map['photoName'];
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'id': id,
      'firstName': F_Name,
      'lastName': L_Name,
      'email': Email,
      'mNumber': M_number,
      'cityName': cityName,
      'photoName': photoName,
    };
    return map;
  }
}
