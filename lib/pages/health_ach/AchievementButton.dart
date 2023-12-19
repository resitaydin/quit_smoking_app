import 'package:flutter/material.dart';
import 'package:loginui/pages/health_ach/DetailPage.dart';

class AchievementButton extends StatelessWidget {
  final String text;
  final String time;
  final String subTextFirst;
  final String subTextLast;
  final double percentage;

  const AchievementButton(this.text, this.time, this.percentage,
      this.subTextFirst, this.subTextLast,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.9),
      child: SizedBox(
        height: 110,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(
                    text, time, subTextFirst, subTextLast, percentage),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 80,
                width: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: CircularProgressIndicator(
                        value: percentage,
                        backgroundColor:
                            const Color.fromARGB(255, 226, 223, 223),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 114, 192, 116)),
                        strokeWidth: 7,
                      ),
                    ),
                    Text(
                      (percentage > 1.0)
                          ? "%100"
                          : "%${(percentage * 100).toStringAsFixed(1)}",
                      style: const TextStyle(fontSize: 18),
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
