// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class elvButton extends StatelessWidget {
  elvButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final Function() onPressed;
  Text child;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
          overlayColor: MaterialStatePropertyAll(Colors.indigo.shade900),
          backgroundColor: const MaterialStatePropertyAll(
            Color.fromARGB(255, 6, 10, 68),
          ),
          shape: MaterialStateProperty.all(const RoundedRectangleBorder()),
        ),
        child: child);
  }
}
