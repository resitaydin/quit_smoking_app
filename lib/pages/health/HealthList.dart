import 'package:flutter/material.dart';
import 'package:loginui/pages/health/HealthButton.dart';
import 'package:loginui/services/local_storage_service.dart';

class HealthList extends StatelessWidget {
  HealthList({super.key});

  final _main_texts = {
    'Blood pressure and pulse return to normal approximately 20 minutes after the last cigarette.',
    'Blood oxygen level returns to normal approximately 8 hours after the last cigarette.',
    'The body gets rid of carbon monoxide approximately 24 hours after the last cigarette.',
    'Nicotine in the body is completely eliminated 48 hours after the last cigarette.',
    'Breathing returns to normal approximately 72 hours after the last cigarette.',
    'Blood circulation returns to normal approximately 2-12 weeks after the last cigarette.',
    'The risk of having a heart attack returns to normal approximately 10-15 years after the last cigarette.',
  };

  final _times_texts = {
    "20 minutes",
    "8 hours",
    "24 hours",
    "2 days",
    "72 hours",
    "5 weeks",
    "10 years",
  };

  final _health_subtexts_first = {
    "Your sleep quality has improved.",
    "Your respiratory function has improved.",
    "Dizziness and weakness in your body has reduced.",
    "Your skin has begun to renew itself.",
    "You are more adapted to high altitude.",
    "Your organ functions have optimized.",
    "Your cardiovascular risk has reduced.",
  };

  final _health_subtexts_second = {
    "Your risk to have of Peripheral Artery Disease (PAD) has reduced.",
    "Your cognitive function has improved.",
    "Your cadence of breathe returned to normal.",
    "Your taste and smell functions has improved.",
    "Your stress has reduced.",
    "Your oxygen transport capacity increased.",
    "Your risk to have Coronary Heart Disease (CHD) has reduced.",
  };

  @override
  Widget build(BuildContext context) {
    int totalMins = LocalStorageService().getTotalMinutesNotSmoked();
    if (totalMins == 0) {
      totalMins = 1;
    }

    final times = {
      totalMins / 20, //20 dakika
      totalMins / (8 * 60), // 8 saat
      totalMins / (24 * 60), //24 saat
      totalMins / (2 * 24 * 60), // 48 saat
      totalMins / (72 * 60), //72 saat
      totalMins / (35 * 24 * 60), //5 hafta(35 gün)
      totalMins / (10 * 365 * 24 * 60), //10 yıl
    };

    List<HealthButton> achievements = [];
    for (int index = 0; index < 7; index++) {
      achievements.add(
        HealthButton(
          _main_texts.elementAt(index),
          _times_texts.elementAt(index),
          times.elementAt(index),
          _health_subtexts_first.elementAt(index),
          _health_subtexts_second.elementAt(index),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Health'),
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
