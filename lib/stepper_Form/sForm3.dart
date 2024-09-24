// ignore_for_file: camel_case_types, prefer_const_constructors, must_be_immutable, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_print, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite_client/common/buttons.dart';
import 'package:sqlite_client/stepper_Form/Model/photo.dart';
import 'package:sqlite_client/stepper_Form/Model/sqLite_DB.dart';
import 'package:sqlite_client/stepper_Form/Utility.dart';
import 'package:sqlite_client/stepper_Form/homeScreen.dart';

class S_Form3 extends StatefulWidget {
  Function() prevPressed;
  S_Form3({
    super.key,
    required this.prevPressed,
  });

  @override
  State<S_Form3> createState() => _S_Form3State();
}

class _S_Form3State extends State<S_Form3> {
  late DB_Main dbStepper;
  late List<form_Model> Data_Form;
  String? firstName;
  String? lastName;
  String? email;
  String? mobNumber;
  String? cityName;

  @override
  void initState() {
    // TODO: implement initState
    Data_Form = [];
    dbStepper = DB_Main();
    refreshImages();
    super.initState();
  }

  refreshImages() {
    dbStepper.getPhotos().then((data) {
      setState(() {
        Data_Form.clear();
        Data_Form.addAll(data);
      });
    });
  }

  pickImageFromGallery() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      firstName = prefs.getString('firName');
      lastName = prefs.getString('lasName');
      email = prefs.getString('emailS');
      mobNumber = prefs.getString('Mno');
      cityName = prefs.getString('city');
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // print("Image picked: ${pickedFile.path}");
        String imgString = Utility.base64String(await pickedFile.readAsBytes());
        // print("Base64 String: $imgString");
        form_Model photo1 = form_Model(
          photoName: imgString,
          F_Name: '$firstName',
          L_Name: '$lastName',
          Email: '$email',
          M_number: '$mobNumber',
          cityName: '$cityName',
        );
        await dbStepper.save(photo1);
        refreshImages();
        // ignore: avoid_print
        print('Save Data Successfully $firstName');
        prefs.clear();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Center(
        //   child: images == null
        //       ? Image.asset('assets/message.png')
        //       : Image.file(
        //           File('$images'),
        //         ),
        // ),
        SizedBox(
          height: 7,
        ),
        ElevatedButton(
          onPressed: () {
            pickImageFromGallery();
          },
          child: Text('Image'),
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
                  )),
            ),
            SizedBox(
              height: 55,
              width: 100,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: elvButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => homeScreen(),
                        ),
                        (Route) => false);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
