import 'package:flutter/material.dart';
import 'package:loginui/pages/achievements/Trophy.dart';

class TrophyList extends StatelessWidget {
  const TrophyList({super.key});

  @override
  Widget build(BuildContext context) {
    const cigarettes = 100; //TODO: fetch data from database
    const smokeFree = 20; //TODO: fetch data from database
    const lifeGained = 8; //TODO: fetch data from database

    final levelsCigarettes = [10, 35, 100];
    final levelsSmokeFree = [5, 20, 60];
    final levelsLifeGained = [5, 10, 30];

    final mainTexts = {
      'Not Smoked Cigarattes: 10',
      'Not Smoked Cigarattes: 35',
      'Not Smoked Cigarattes: 100',
      'Sigara içmeyen gün sayisi 5 gün',
      'Sigara içmeyen gün sayisi 20 gün',
      'Sigara içmeyen gün sayisi 60 gün',
      'Kazanilan ömür 5 gün',
      'Kazanilan ömür 20 gün',
      'Kazanilan ömür 60 gün',
    };

    final images = [
      'assets/images/trophy_silver.jpg',
      'assets/images/trophy_brown.jpg',
      'assets/images/trophy.png'
    ];

    final imagesRed = [
      'assets/images/red1.png',
      'assets/images/red2.png',
      'assets/images/red3.png'
    ];

    List<Trophy> achievements = [];
    print(mainTexts.length);
    achievements.add(const Trophy(
        "First step is quitting smoke.", "assets/images/rocket1.png", true));
    for (int index = 0; index < 3; index++) {
      achievements.add(
        Trophy(
          mainTexts.elementAt(index),
          imagesRed.elementAt(index),
          cigarettes >= levelsCigarettes[index],
        ),
      );
    }
    for (int index = 0; index < 3; index++) {
      achievements.add(
        Trophy(
          mainTexts.elementAt(index + 3),
          images.elementAt(index),
          smokeFree >= levelsSmokeFree[index],
        ),
      );
    }
    for (int index = 0; index < 3; index++) {
      achievements.add(
        Trophy(
          mainTexts.elementAt(index + 6),
          images.elementAt(index),
          lifeGained >= levelsLifeGained[index],
        ),
      );
    }
    return Scaffold(appBar: AppBar(
        title: const Text('Achievements'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.green.shade700,
                Colors.green.shade400,
              ],
            ),
          ),
        ),
      ),
      body: ListView(children: achievements));
  }
}
