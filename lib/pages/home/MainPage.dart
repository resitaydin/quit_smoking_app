import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loginui/pages/social/firebase_options.dart';
import 'package:loginui/services/auth.dart';
import 'package:loginui/services/local_storage_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final AuthService _auth = AuthService();

  int current_smoke_amount = 0;

  Timer? countUppTimer;
  Duration myDuration = const Duration();
  double savedMoney = 0.0;

  @override
  void initState() {
    super.initState();
    final Future<FirebaseApp> fApp = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    fApp.then((_) {
      LocalStorageService().setData().then((_) {
        setState(() {
          myDuration = Duration(
              seconds: LocalStorageService().getTotalSecondsNotSmoked());
        });
        current_smoke_amount = LocalStorageService().calculateSmokeAmount();
        savedMoney = LocalStorageService().calculateSavedMoney();
        startTimer();
      });
    });
  }

  void startTimer() {
    countUppTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountUpp());
  }

  @override
  void dispose() {
    countUppTimer?.cancel(); // Cancel the timer when disposing the widget
    super.dispose();
  }

  // Step 6
  void setCountUpp() {
    const incrementSecondsBy = 1;
    if (mounted) {
      // Check if the widget is still in the tree
      setState(() {
        final seconds = myDuration.inSeconds + incrementSecondsBy;
        myDuration = Duration(seconds: seconds);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Quit Smoking'),
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
          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.logout),
          //     onPressed: () {
          //       _auth.signOut();
          //     },
          //   ),
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            children: [
              buildTime(), // Time part
              const SizedBox(
                  height:
                      20), // Leave some space between the time and the widgets
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 2.55,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 25.0),
                    mainAxisSpacing: 6.0,
                    crossAxisSpacing: 2.0,
                    children: <Widget>[
                      // Widget 1 (Smoke Amount)
                      infoCard(
                          time: '$current_smoke_amount',
                          header: 'Smoke Amount'),

                      // Widget 2 (Saved Money)
                      infoCard(
                          time: '₺${savedMoney.toInt()}',
                          header: 'Saved Money'),

                      // Widget 3 (Days Quit)
                      infoCard(
                          time: '  ${myDuration.inDays}  ',
                          header: 'Days Quit'),

                      // Widget 4 (Gained Health)
                      infoCard(
                        time:
                            ' %${min((myDuration.inDays / 180 * 100).toInt(), 100)} ',
                        header: 'Regained Health',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoCard({required String time, required String header}) => Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: 5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              header,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 0),
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ],
        ),
      );

  Widget buildTime() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(myDuration.inDays);
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTimeCard(time: days, header: "DAYS"),
          const SizedBox(width: 10),
          buildTimeCard(time: hours, header: "HOURS"),
          const SizedBox(width: 10),
          buildTimeCard(time: minutes, header: "MINUTES"),
          const SizedBox(width: 10),
          buildTimeCard(time: seconds, header: "SECONDS"),
        ],
      ),
    );
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
            ),
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(header),
        ],
      );
}
