import 'package:flutter/material.dart';
import 'package:loginui/pages/achievements/Trophy.dart';
import 'package:loginui/services/local_storage_service.dart';

class TrophyList extends StatelessWidget {
  const TrophyList({super.key});

  @override
  Widget build(BuildContext context) {
    int cigarettes = LocalStorageService().calculateSmokeAmount();
    int smokeFree = LocalStorageService().getTotalDaysNotSmoked();

    // One cigarette shortens life by 12 minutes
    int lifeGainedInMinutes = cigarettes * 12;

    // Convert minutes to days, hours, and minutes
    int lifeGained = lifeGainedInMinutes ~/ (24 * 60); // integer divison

    final levelsCigarettes = [10, 35, 100];
    final levelsSmokeFree = [5, 20, 60];
    final levelsLifeGained = [5, 10, 30];

    final mainTexts = {
      'Not Smoked Cigarattes: 10',
      'Not Smoked Cigarattes: 35',
      'Not Smoked Cigarattes: 100',
      'Days without smoking: 5 days',
      'Days without smoking: 20 days',
      'Days without smoking: 60 days',
      'Life regained: 5 days',
      'Life regained: 20 days',
      'Life regained: 60 days',
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
    return Scaffold(
        appBar: AppBar(
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
