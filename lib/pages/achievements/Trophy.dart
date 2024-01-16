import 'package:flutter/material.dart';

class Trophy extends StatelessWidget {
  final String text;
  final String image;
  final bool unLocked;

  const Trophy(this.text, this.image, this.unLocked, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.9),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: unLocked ? () {} : null,
          style: ElevatedButton.styleFrom(
            enableFeedback: false,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.transparent; // Disables the splash effect
                }
                return Colors.transparent; // Defer to the widget's default.
              },
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 110,
                width: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: CircleAvatar(
                        radius: 48, // Image radius
                        backgroundImage: AssetImage(
                            unLocked ? image : "assets/images/trophy_gray.png"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                  selectionColor: Colors.black12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
