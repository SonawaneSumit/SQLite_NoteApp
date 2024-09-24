// ignore_for_file: non_constant_identifier_names, camel_case_types, unnecessary_null_comparison

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sqlite_client/AddForm/Model/City.dart';
import 'package:sqlite_client/AddForm/Model/State.dart';
import 'package:sqlite_client/AddForm/Model/dbSQ_handler.dart';
import 'package:sqlite_client/AddForm/homeScreen.dart';
import 'package:sqlite_client/AddForm/notes.dart';

class Add_driver extends StatefulWidget {
  const Add_driver({super.key});

  @override
  State<Add_driver> createState() => _Add_driverState();
}

class _Add_driverState extends State<Add_driver> {
  final FomrKey = GlobalKey<FormState>();
  final _formkey = GlobalKey<FormState>();
  bool loadingAPI = false;
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var DateBirth = TextEditingController();
  var emailId = TextEditingController();
  var mobileNo = TextEditingController();
  final _userEditTextController = TextEditingController(/* text: 'Mrs' */);
  String? selectedStateId;
  String? selectedCity;
  // String? finalDate;
  // File? imageFile;
  // final picker = ImagePicker();
  late String displayDate; // For displaying to the user
  late String apiDate; // For sending to the API

  DB_Helper? dbHelper;
  Future<List<NotesModel>>? notesList;

  List<StatesList> StateItem = [];
  List<CityList> CityItem = [];

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  void initState() {
    dbHelper = DB_Helper();
    loadData();
    listStates();
    super.initState();
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        displayDate = DateFormat('dd-MMM-yyyy').format(picked);

        apiDate = DateFormat('yyyy-MM-dd').format(picked);
        DateBirth.text = displayDate;
      });
    }
  }

  // addDriver() async {
  //   // SharedPreferences pref = await SharedPreferences.getInstance();
  //   // var user_id = pref.getString('userID');
  //   // var api_Token = pref.getString('APItoken');

  //   try {
  //     var request = http.MultipartRequest(
  //         'POST', Uri.parse('https://wetap.in/2023/transpo/app_driver_add'));
  //     request.fields.addAll({
  //       "user_id": "112",
  //       "api_token":
  //           "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyZWdfdHlwZSI6IjIiLCJyZWdfaWQiOiIxMTIiLCJyZWdfZW1haWwiOiJrZmNpbmRpYUBnbWFpbC5jb20iLCJyZWdfbW9iaWxlIjoiOTEzOTkxNzUxNyIsInJlZ19uYW1lIjoia2ZjIEluZGlhIiwia2V5IjoxMjM0NTZ9.GemN5-LntUnVd93244N_HzP72S11XV6lvkkNqXlEUN4",
  //       "first_name": firstName.text.trim(),
  //       "last_name": lastName.text.trim(),
  //       "email": emailId.text.trim(),
  //       "mobile_no": mobileNo.text.trim(),
  //       "birthdate": apiDate.trim(),
  //       "address": FullAdd.text.trim(),
  //       "city": "$selectedCity",
  //       // "pan_number": "1234",
  //       // "aadhar_number": "123456",
  //       // "image": imageString,
  //     });
  //     if (imageFile != null) {
  //       var image = await http.MultipartFile.fromPath('image', imageFile!.path);
  //       request.files.add(image);
  //     }

  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);
  //     if (response.statusCode == 200) {
  //       var resbody = jsonDecode(response.body);
  //       if (resbody["result"] == true) {
  //         Fluttertoast.showToast(msg: resbody["reason"].toString());
  //         // Navigator.pushReplacement(
  //         //     context,
  //         //     MaterialPageRoute(
  //         //         builder: (context) => const bottomTabBar(initialIndex: 3)));
  //       } else {
  //         Fluttertoast.showToast(msg: resbody["result"].toString());
  //       }
  //     }
  //   } catch (error) {
  //     Fluttertoast.showToast(msg: error.toString());
  //   }
  // }

  listStates() async {
    try {
      var res = await http
          .post(Uri.parse('https://wetap.in/2023/transpo/state_list'), body: {
        "country_id": "101",
      });
      if (res.statusCode == 200) {
        Map<String, dynamic> resBody = jsonDecode(res.body);
        if (resBody["states_list"] != null) {
          if (mounted) {
            setState(() {
              StateItem = (resBody["states_list"] as List<dynamic>)
                  .map((item) => StatesList.fromJson(item))
                  .toList();
            });
          }
        }
      }
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  listCity() async {
    try {
      var res = await http
          .post(Uri.parse('https://wetap.in/2023/transpo/city_list'), body: {
        "state_id": "$selectedStateId",
      });
      if (res.statusCode == 200) {
        Map<String, dynamic> resBody = jsonDecode(res.body);
        if (resBody["city_list"] != null) {
          if (mounted) {
            setState(() {
              CityItem = (resBody["city_list"] as List<dynamic>)
                  .map((item) => CityList.fromJson(item))
                  .toList();
            });
          }
        }
      }
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          shadowColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
            ),
          ),
          flexibleSpace: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.16),
                child: const Row(
                  children: [
                    Text(
                      "Add Driver",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          )),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.yellowAccent.shade700,
          onPressed: () {
            // if (_formkey.currentState!.validate() &&
            //     FomrKey.currentState!.validate()) {
            //   addDriver();
            // }

            if (_formkey.currentState!.validate() &&
                FomrKey.currentState!.validate()) {
              dbHelper!
                  .insert(NotesModel(
                      title: firstName.text.trim(),
                      age: "${mobileNo.text.trim().toString()}",
                      description: emailId.text.trim(),
                      email: selectedCity!))
                  .then(
                (value) {
                  print("data added");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const home_Screen()),
                      (Route) => false);
                  setState(
                    () {
                      notesList = dbHelper!.getNotesList();
                    },
                  );
                },
              ).onError((error, stackTrace) {
                print(error.toString());
              });
            }
          },
          label: const Text(
            "SUBMIT",
            style: TextStyle(color: Colors.black),
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 140,
                width: MediaQuery.sizeOf(context).width,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.09),
                          child: Row(
                            children: [
                              Container(
                                height: 35,
                                width: 35,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.yellowAccent.shade700),
                                child: const Icon(
                                  FontAwesomeIcons.userTie,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.06),
                          child: const Row(
                            children: [
                              Text(
                                "Add Driver",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Form(
                    key: FomrKey,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 17, right: 17),
                      child: Column(
                        children: [
                          TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(13)
                            ],
                            controller: firstName,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.green.shade700,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (VechicleNumber) {
                              if (VechicleNumber == null ||
                                  VechicleNumber.isEmpty) {
                                return '';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              label: Text(
                                'First Name',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              contentPadding: EdgeInsets.only(left: 15),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     top: 24,
                          //   ),
                          //   child: TextFormField(
                          //     controller: lastName,
                          //     autovalidateMode:
                          //         AutovalidateMode.onUserInteraction,
                          //     keyboardType: TextInputType.text,
                          //     cursorColor: Colors.green.shade700,
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return '';
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     decoration: const InputDecoration(
                          //       label: Text(
                          //         'Last Name',
                          //         style: TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.w500),
                          //       ),
                          //       contentPadding: EdgeInsets.only(left: 15),
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.always,
                          //       enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.black),
                          //       ),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.black),
                          //       ),
                          //       errorBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(color: Colors.red)),
                          //       focusedErrorBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(color: Colors.red)),
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 24),
                          //   child: TextFormField(
                          //     autovalidateMode:
                          //         AutovalidateMode.onUserInteraction,
                          //     controller: DateBirth,
                          //     keyboardType: TextInputType.none,
                          //     cursorColor: Colors.green.shade700,
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return '';
                          //       }
                          //       return null;
                          //     },
                          //     decoration: const InputDecoration(
                          //       suffixIcon: Icon(
                          //         Icons.calendar_month,
                          //         color: Colors.black,
                          //       ),
                          //       label: Text(
                          //         'Date of Birth',
                          //         style: TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.w500),
                          //       ),
                          //       contentPadding: EdgeInsets.only(left: 15),
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.always,
                          //       enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.black),
                          //       ),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.black),
                          //       ),
                          //       errorBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(color: Colors.red)),
                          //       focusedErrorBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(color: Colors.red)),
                          //     ),
                          //     onTap: _selectDate,
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: emailId,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.green.shade700,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                label: Text(
                                  'Email Id',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                contentPadding: EdgeInsets.only(left: 15),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: mobileNo,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.green.shade700,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                label: Text(
                                  'Mobile No',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                contentPadding: EdgeInsets.only(left: 15),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                            ),
                          ),
                          //
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 24),
                          //   child: TextFormField(
                          //     autovalidateMode:
                          //         AutovalidateMode.onUserInteraction,
                          //     controller: PanNo,
                          //     keyboardType: TextInputType.multiline,
                          //     cursorColor: Colors.green.shade700,
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return '';
                          //       } else {
                          //         return null;
                          //       }
                          //     },
                          //     decoration: const InputDecoration(
                          //       label: Text(
                          //         'PAN Card No',
                          //         style: TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.w500),
                          //       ),
                          //       contentPadding: EdgeInsets.only(left: 15),
                          //       floatingLabelBehavior:
                          //           FloatingLabelBehavior.always,
                          //       enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.black),
                          //       ),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.black),
                          //       ),
                          //       errorBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(color: Colors.red)),
                          //       focusedErrorBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(color: Colors.red)),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: height * 0.088,
                  // ),

                  //
                  ///
                  ////
                  ////
                  ///
                  Form(
                    key: _formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 24, left: 17, right: 17),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownSearch<String>(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Select the Vehicle';
                                    }
                                    return null;
                                  },
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      contentPadding: EdgeInsets.only(left: 15),
                                      label: Text(
                                        'State',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  popupProps: PopupProps.dialog(
                                    constraints: BoxConstraints.tight(Size(
                                        0, MediaQuery.sizeOf(context).width)),
                                    title: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Select Item...',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    searchFieldProps: TextFieldProps(
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                      cursorColor: Colors.yellowAccent.shade700,
                                      controller: _userEditTextController,
                                      decoration: InputDecoration(
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: TextButton(
                                          onPressed: () {
                                            _userEditTextController.clear();
                                          },
                                          child: const Text(
                                            "Clear",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    showSearchBox: true,
                                    showSelectedItems: true,
                                  ),
                                  items: StateItem.map((state) => state.name!)
                                      .toList(),
                                  onChanged: (value) {
                                    if (StateItem != null) {
                                      // Find the selected state by name and get its ID
                                      final selectedState =
                                          StateItem.firstWhere(
                                              (state) => state.name == value);
                                      if (selectedState != null) {
                                        setState(() {
                                          selectedStateId =
                                              selectedState.id; // Save the ID
                                          listCity();
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 24, left: 17, right: 17),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownSearch<String>(
                                  validator: (vehicleMakerL) {
                                    if (vehicleMakerL == 'Select City') {
                                      return '';
                                    }
                                    return null;
                                  },
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      contentPadding: EdgeInsets.only(left: 15),
                                      label: Text(
                                        'City',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  popupProps: PopupProps.dialog(
                                    constraints: BoxConstraints.tight(Size(
                                        0, MediaQuery.sizeOf(context).width)),
                                    title: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Select Item...',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    searchFieldProps: TextFieldProps(
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                      cursorColor: Colors.yellowAccent.shade700,
                                      controller: _userEditTextController,
                                      decoration: InputDecoration(
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: TextButton(
                                          child: const Text(
                                            "Clear",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onPressed: () {
                                            _userEditTextController.clear();
                                          },
                                        ),
                                      ),
                                    ),
                                    showSearchBox: true,
                                    showSelectedItems: true,
                                  ),
                                  items: CityItem.map((City) => City.name!)
                                      .toList(),
                                  onChanged: (value) {
                                    final selected_City = CityItem.firstWhere(
                                        (city) => city.name == value);
                                    setState(() {
                                      selectedCity = selected_City.name;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(top: 24, left: 17, right: 17),
                  //   child: TextFormField(
                  //     autovalidateMode: AutovalidateMode.onUserInteraction,
                  //     controller: FullAdd,
                  //     keyboardType: TextInputType.streetAddress,
                  //     cursorColor: Colors.green.shade700,
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return '';
                  //       } else {
                  //         return null;
                  //       }
                  //     },
                  //     decoration: const InputDecoration(
                  //       label: Text(
                  //         'Full Address',
                  //         style: TextStyle(
                  //             color: Colors.black, fontWeight: FontWeight.w500),
                  //       ),
                  //       contentPadding: EdgeInsets.only(left: 15),
                  //       floatingLabelBehavior: FloatingLabelBehavior.always,
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(color: Colors.black),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(color: Colors.black),
                  //       ),
                  //       errorBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.red)),
                  //       focusedErrorBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.red)),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: height * 0.088,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _imgFromGallery() async {
  //   await picker
  //       .pickImage(source: ImageSource.gallery, imageQuality: 25)
  //       .then((value) {
  //     if (value != null) {
  //       _cropImage(File(value.path));
  //     }
  //   });
  // }

  // _imgFromCamera() async {
  //   await picker
  //       .pickImage(source: ImageSource.camera, imageQuality: 25)
  //       .then((value) {
  //     if (value != null) {
  //       _cropImage(File(value.path));
  //     } else {
  //       Fluttertoast.showToast(msg: 'Please allow access to the camera');
  //     }
  //   });
  // }

  // _cropImage(File imgFile) async {
  //   final croppedFile = await ImageCropper().cropImage(
  //       sourcePath: imgFile.path,
  //       aspectRatioPresets: Platform.isAndroid
  //           ? [
  //               CropAspectRatioPreset.square,
  //               CropAspectRatioPreset.ratio3x2,
  //               CropAspectRatioPreset.original,
  //               CropAspectRatioPreset.ratio4x3,
  //               CropAspectRatioPreset.ratio16x9
  //             ]
  //           : [
  //               CropAspectRatioPreset.original,
  //               CropAspectRatioPreset.square,
  //               CropAspectRatioPreset.ratio3x2,
  //               CropAspectRatioPreset.ratio4x3,
  //               CropAspectRatioPreset.ratio5x3,
  //               CropAspectRatioPreset.ratio5x4,
  //               CropAspectRatioPreset.ratio7x5,
  //               CropAspectRatioPreset.ratio16x9
  //             ],
  //       uiSettings: [
  //         AndroidUiSettings(
  //             toolbarTitle: "Image Cropper",
  //             toolbarColor: AppColors.tabsColor,
  //             toolbarWidgetColor: Colors.white,
  //             activeControlsWidgetColor: AppColors.tabsColor,
  //             initAspectRatio: CropAspectRatioPreset.original,
  //             lockAspectRatio: false),
  //         IOSUiSettings(
  //           title: "Image Cropper",
  //         )
  //       ]);
  //   if (croppedFile != null) {
  //     imageCache.clear();
  //     if (mounted) {
  //       setState(() {
  //         imageFile = File(croppedFile.path);
  //         // Driver_Image();
  //       });
  //     }
  //   }
  // }
}
