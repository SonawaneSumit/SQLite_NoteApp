// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, deprecated_member_use, prefer_typing_uninitialized_variables, camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite_client/common/buttons.dart';

class S_Form1 extends StatefulWidget {
  VoidCallback onNextPressed;
  Function() prevPressed;
  S_Form1({super.key, required this.onNextPressed, required this.prevPressed});

  @override
  State<S_Form1> createState() => _S_Form1State();
}

class _S_Form1State extends State<S_Form1> {
  var FName = TextEditingController();
  var LName = TextEditingController();
  var Time;

  saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firName', FName.text.trim());
    await prefs.setString('lasName', LName.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (Time == null || now.difference(Time) > Duration(seconds: 2)) {
          Time = now;
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Press Back Button Again to Exit')));
          return false;
        }

        return true;
      },
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: FName,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("First Name"),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: LName,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Last Name"),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
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
                      child: Text('Previous',
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
                    child: Text(
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
      ),
    );
  }
}
