import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String text;
  final String time;
  final String subTextFirst;
  final String subTextLast;
  final double percentage;

  const DetailPage(this.text, this.time,  this.subTextFirst, this.subTextLast,this.percentage,  {super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Achievements'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200,
                  width: 200,
                  child: CircularProgressIndicator(
                    value: percentage,
                    backgroundColor: const Color.fromARGB(255, 226, 223, 223),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 114, 192, 116)),
                    strokeWidth: 7,
                  ),
                ),
                Text(
                  (percentage > 1.0)
                      ? "%100"
                      : "%${(percentage * 100).toStringAsFixed(1)}",
                  style: const TextStyle(fontSize: 32),
                ),
              ],
            ),
            Container(height: 19),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            Container(height: 9),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Container(height: 9),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            Container(height: 9),
             Text(
              subTextFirst,
              style: TextStyle(fontSize: 16, 
              color:(percentage > 1.0) ? Colors.green : Colors.black
              ),
              textAlign: TextAlign.center,
            ),
            Container(height: 9),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            Container(height: 9),
             Text(
              subTextFirst,
              style: TextStyle(fontSize: 16, 
              color:(percentage > 1.0) ? Colors.green : Colors.black
              ),
              textAlign: TextAlign.center,
            ),
            Container(height: 9),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            Container(height: 9),
            Text(
              time,
              style: const TextStyle(fontSize: 16),
            ),
            Container(height: 9),
            Container(
              height: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
