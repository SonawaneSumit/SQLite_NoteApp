// ignore_for_file: camel_case_types, unnecessary_null_comparison, must_be_immutable, non_constant_identifier_names, avoid_types_as_parameter_names

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite_client/AddForm/Model/City.dart';
import 'package:sqlite_client/AddForm/Model/State.dart';
import 'package:http/http.dart' as http;
import 'package:sqlite_client/common/buttons.dart';

class S_Form2 extends StatefulWidget {
  VoidCallback onNextPressed;
  Function() prevPressed;
  S_Form2({super.key, required this.onNextPressed, required this.prevPressed});

  @override
  State<S_Form2> createState() => _S_Form2State();
}

class _S_Form2State extends State<S_Form2> {
  var MobileNo = TextEditingController();
  var EmailId = TextEditingController();

  List<StatesList> StateItem = [];
  List<CityList> CityItem = [];

  final _userEditTextController = TextEditingController(/* text: 'Mrs' */);
  String? selectedStateId;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    listStates();
  }

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

  saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Mno', MobileNo.text.trim());
    await prefs.setString('emailS', EmailId.text.trim());
    await prefs.setString('city', selectedCity ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: TextFormField(
            controller: EmailId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Email"),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: MobileNo,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Mob Number"),
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
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
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text(
                        'State',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  popupProps: PopupProps.dialog(
                    constraints: BoxConstraints.tight(
                        Size(0, MediaQuery.sizeOf(context).width)),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Select Item...',
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      cursorColor: Colors.yellowAccent.shade700,
                      controller: _userEditTextController,
                      decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
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
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    showSearchBox: true,
                    showSelectedItems: true,
                  ),
                  items: StateItem.map((state) => state.name!).toList(),
                  onChanged: (value) {
                    if (StateItem != null) {
                      // Find the selected state by name and get its ID
                      final selectedState =
                          StateItem.firstWhere((state) => state.name == value);
                      if (selectedState != null) {
                        setState(() {
                          selectedStateId = selectedState.id; // Save the ID
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
          padding: const EdgeInsets.only(top: 24),
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
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text(
                        'City',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  popupProps: PopupProps.dialog(
                    constraints: BoxConstraints.tight(
                        Size(0, MediaQuery.sizeOf(context).width)),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Select Item...',
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      cursorColor: Colors.yellowAccent.shade700,
                      controller: _userEditTextController,
                      decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        suffixIcon: TextButton(
                          child: const Text(
                            "Clear",
                            style: TextStyle(color: Colors.black),
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
                  items: CityItem.map((City) => City.name!).toList(),
                  onChanged: (value) {
                    final selected_City =
                        CityItem.firstWhere((city) => city.name == value);
                    setState(() {
                      selectedCity = selected_City.name;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 55,
              width: 100,
              child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: elvButton(
                    onPressed: () {
                      widget.prevPressed();
                    },
                    child: const Text('Previous',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white)),
                  )

                  // ElevatedButton(
                  //   onPressed: () {
                  //     widget.onNextPressed();
                  //   },
                  //   style: ButtonStyle(
                  //       padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                  //       overlayColor:
                  //           MaterialStatePropertyAll(Colors.indigo.shade900),
                  //       backgroundColor: const MaterialStatePropertyAll(
                  //         Color.fromARGB(255, 6, 10, 68),
                  //       ),
                  //       shape: MaterialStateProperty.all(
                  //           RoundedRectangleBorder())),
                  //   child: const Text(
                  //     'Previous',
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 16,
                  //         color: Colors.white),
                  //   ),
                  // ),
                  ),
            ),
            SizedBox(
              height: 55,
              width: 100,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: elvButton(
                  onPressed: () {
                    widget.onNextPressed();
                    saveData();
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),

                // ElevatedButton(
                //   onPressed: () {
                //     widget.onNextPressed();
                //   },
                //   style: ButtonStyle(
                //     overlayColor:
                //         MaterialStatePropertyAll(Colors.indigo.shade900),
                //     backgroundColor: const MaterialStatePropertyAll(
                //       Color.fromARGB(255, 6, 10, 68),
                //     ),
                //     shape:
                //         MaterialStateProperty.all(RoundedRectangleBorder()),
                //   ),
                //   child: const Text(
                //     'Next',
                //     style: TextStyle(
                //         fontWeight: FontWeight.w500,
                //         fontSize: 16,
                //         color: Colors.white),
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
