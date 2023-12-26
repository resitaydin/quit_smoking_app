import 'package:flutter/material.dart';

class UiButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onTap;

  const UiButton({Key? key, required this.buttonName, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Colors.green), // Change color here
        ),
        child: Center(
          child: Text(
            buttonName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
