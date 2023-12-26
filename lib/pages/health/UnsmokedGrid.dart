import 'package:flutter/material.dart';

class UnsmokedGrid extends StatefulWidget {
  const UnsmokedGrid({Key? key}) : super(key: key);

  @override
  State<UnsmokedGrid> createState() => UnsmokedGrigState();
}

class UnsmokedGrigState extends State<UnsmokedGrid> {
  @override
  Widget build(BuildContext context) {
    const cigarettes = 100; //TODO: fetch data from database
    const smokeFree = 20; //TODO: fetch data from database
    const lifeGained = 12; //TODO: fetch data from database

    final levelsCigarettes = [10, 35, 100, 250];
    final levelsSmokeFree = [5, 20, 60, 250];
    final levelsLifeGained = [5, 10, 30, 90];

    Map<String, List<int>> levelThresholds = {
      'Cigarettes not Smoked': levelsCigarettes,
      'Smoke free (days)': levelsSmokeFree,
      'Life regained (days)': levelsLifeGained,
    };

    final images = [
      'assets/images/trophy_pink.jpg',
      'assets/images/trophy_silver.jpg',
      'assets/images/trophy_brown.jpg',
      'assets/images/trophy.png'
    ];

    // Define your trophy levels here
    Map<String, int> trophyLevels = {
      'Cigarettes not Smoked': cigarettes,
      'Smoke free (days)': smokeFree,
      'Life regained (days)': lifeGained,
    };

    return ListView(
      children: trophyLevels.entries.map((entry) {
        return Column(
          children: [
            Text(
              entry.key,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                              ? images.elementAt(index)
                              : 'assets/images/trophy_gray.png'),
                      Text(levelThresholds[entry.key]![index].toString(),
                          style: const TextStyle(fontSize: 9.0)),
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
