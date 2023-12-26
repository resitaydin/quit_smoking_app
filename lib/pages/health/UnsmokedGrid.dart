import 'package:flutter/material.dart';

class UnsmokedGrid extends StatefulWidget {
  const UnsmokedGrid({Key? key}) : super(key: key);

  @override
  State<UnsmokedGrid> createState() => UnsmokedGrigState();
}

class UnsmokedGrigState extends State<UnsmokedGrid> {
  @override
  Widget build(BuildContext context) {
    final cigarettes = 100; //TODO: fetch data from database
    final smoke_free = 20; //TODO: fetch data from database
    final life_gained = 12; //TODO: fetch data from database

    final _levels_cigarettes = [10, 35, 100, 250];
    final _levels_smoke_free = [5, 20, 60, 250];
    final _levels_life_gained = [5, 10, 30, 90];

    Map<String, List<int>> levelThresholds = {
      'Cigarettes not Smoked': _levels_cigarettes,
      'Smoke free (days)': _levels_smoke_free,
      'Life regained (days)': _levels_life_gained,
    };

    final _images = [
      'assets/images/trophy_pink.jpg',
      'assets/images/trophy_silver.jpg',
      'assets/images/trophy_brown.jpg',
      'assets/images/trophy.png'
    ];

    // Define your trophy levels here
    Map<String, int> trophyLevels = {
      'Cigarettes not Smoked': cigarettes,
      'Smoke free (days)': smoke_free,
      'Life regained (days)': life_gained,
    };

    return ListView(
      children: trophyLevels.entries.map((entry) {
        return Column(
          children: [
            Text(
              entry.key,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.all(10),
              children: List.generate(4, (index) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                          entry.value >= levelThresholds[entry.key]![index]
                              ? _images.elementAt(index)
                              : 'assets/images/trophy_gray.png'),
                      Text(levelThresholds[entry.key]![index].toString(),
                          style: TextStyle(fontSize: 9.0)),
                    ],
                  ),
                );
              }),
            ),
          ],
        );
      }).toList(),
    );
  }
}
