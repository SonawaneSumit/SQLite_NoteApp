// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sqlite_client/stepper_Form/sForm1.dart';
import 'package:sqlite_client/stepper_Form/sForm2.dart';
import 'package:sqlite_client/stepper_Form/sForm3.dart';

class stepper_Form extends StatefulWidget {
  const stepper_Form({super.key});

  @override
  State<stepper_Form> createState() => _stepper_FormState();
}

class _stepper_FormState extends State<stepper_Form> {
  int current_ind = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Stepper(
          connectorThickness: 1.5,
          type: StepperType.horizontal,
          physics: const ClampingScrollPhysics(),
          currentStep: current_ind,
          onStepTapped: null,
          onStepCancel: null,
          controlsBuilder: (context, controller) {
            return Container(); // Hide Continue And Cancel Button
          },
          onStepContinue: () {
            if (current_ind <= 5) {
              setState(() {
                current_ind += 1;
              });
            }
          },
          steps: [
            Step(
              title: const Text(""),
              // label: Text('data'),
              content: S_Form1(onNextPressed: continued, prevPressed: previous),
              isActive: current_ind == 0,
              state: current_ind > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
                title: const Text(""),
                content:
                    S_Form2(onNextPressed: continued, prevPressed: previous),
                isActive: current_ind == 1,
                state:
                    current_ind > 1 ? StepState.complete : StepState.indexed),
            Step(
                title: const Text(""),
                content: S_Form3(
                  prevPressed: previous,
                ),
                isActive: current_ind == 2,
                state:
                    current_ind > 2 ? StepState.complete : StepState.indexed),
          ],
        ),

        // child: Container(
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: Stepper(
        //           // physics: ScrollPhysics(),
        //           controller: ScrollController(),
        //           type: StepperType.horizontal,
        //           // currentStep: _currentStep,
        //           // onStepTapped: (step) => setState(() => _currentStep = step),
        //           // onStepContinue: _currentStep < 2
        //           //     ? () => setState(() => _currentStep += 1)
        //           //     : null,
        //           // onStepCancel: _currentStep > 0
        //           //     ? () => setState(() => _currentStep -= 1)
        //           //     : null,
        //           steps: [
        //             Step(
        //               title: const Text(
        //                 'Credentials',
        //                 style: TextStyle(fontSize: 12),
        //               ),
        //               content: TextFormField(
        //                 keyboardType: TextInputType.emailAddress,
        //                 decoration: InputDecoration(
        //                   /*  hintStyle: _hintStyle, */
        //                   hintText: 'Email',
        //                 ),
        //               ),
        //               state: _currentStep == 0
        //                   ? StepState.editing
        //                   : StepState.complete,
        //               isActive: _currentStep == 0,
        //             ),
        //             Step(
        //               title: const Text(
        //                 'Postal Address',
        //                 style: TextStyle(fontSize: 12),
        //               ),
        //               content: TextFormField(
        //                 keyboardType: TextInputType.emailAddress,
        //                 decoration: InputDecoration(
        //                     /* hintStyle: _hintStyle */ hintText: 'Address'),
        //               ),
        //               state: _currentStep == 1
        //                   ? StepState.editing
        //                   : StepState.complete,
        //               isActive: _currentStep == 1,
        //             ),
        //             Step(
        //               title: const Text(
        //                 'Number',
        //                 style: TextStyle(fontSize: 12),
        //               ),
        //               content: TextFormField(
        //                 keyboardType: TextInputType.number,
        //                 decoration: InputDecoration(
        //                     /* hintStyle:, */ hintText: 'Number'),
        //               ),
        //               state: _currentStep == 2
        //                   ? StepState.editing
        //                   : StepState.complete,
        //               isActive: _currentStep == 2,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  continued() {
    if (current_ind < 4) {
      setState(() {
        current_ind += 1;
      });
    }
  }

  previous() {
    if (current_ind < 4 && current_ind != 0) {
      setState(() {
        current_ind -= 1;
      });
    } else {
      return null;
    }
  }

  List<Step> getSteps() => [];
}
