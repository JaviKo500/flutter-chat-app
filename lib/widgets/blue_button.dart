
import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String placeholder;
  final Function() onPressed;

  const BlueButton({
    Key? key, 
    required this.placeholder, 
    required this.onPressed
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Container(
        alignment: AlignmentDirectional.center,
        width: double.infinity,
        height: 50,
        child: Text(placeholder, style: const TextStyle(color: Colors.white, fontSize: 18),),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(32)
        ),
      ),
      onPressed: onPressed
    );
  }
}