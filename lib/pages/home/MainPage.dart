import 'dart:async';
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

  DateTime lastDateSmoked = DateTime.now();
  int cigaratte_daily_smoked = 0;
  int cigaratte_amount_per_pack = 0;
  int price_per_pack = 0;

  int current_smoke_amount = 0;

  Timer? countUppTimer;
  Duration myDuration = const Duration();
  double savedMoney = 0.0;
  int total_seconds = 0;

  @override
  void initState() {
    super.initState();
    final Future<FirebaseApp> fApp = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    fApp.then((_) {
      LocalStorageService().setData().then((_) {
          setState(() {
            lastDateSmoked = LocalStorageService().getLastDateSmoked();
            cigaratte_daily_smoked = LocalStorageService().getCigaratteDailySmoked();
            cigaratte_amount_per_pack = LocalStorageService().getCigaratteAmountPerPack();
            price_per_pack = LocalStorageService().getPricePerPack();

            Duration difference = DateTime.now().difference(lastDateSmoked);
            total_seconds = difference.inSeconds;
            myDuration = Duration(seconds: total_seconds);
          });
          current_smoke_amount = calculateSmokeAmount();
          savedMoney = calculateSavedMoney();
          startTimer();
      });
    });
  }

  double calculateSavedMoney() {
    int cigarattesNotSmoked =
        calculateSmokeAmount(); // number of cigarattes not smoked
    double pricePerCigaratte = price_per_pack / cigaratte_amount_per_pack;
    return pricePerCigaratte * cigarattesNotSmoked; // return saved money
  }

  int calculateSmokeAmount() {
    return (cigaratte_daily_smoked * (total_seconds / 86400))
        .toInt(); //  We're dividing daily_smoked_amount to days, 1 day is 86400 seconds.
  }

  void startTimer() {
    countUppTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountUpp());
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
          title: const Text('Main Page'),
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _auth.signOut();
              },
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
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
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    padding: const EdgeInsets.all(4.0),
                    mainAxisSpacing:
                        2.0, // Make the widgets close to each other
                    crossAxisSpacing:
                        2.0, // Make the widgets close to each other
                    children: <Widget>[
                      // Widget 1
                      infoCard(
                          time: '$current_smoke_amount',
                          header: 'Smoke Amount'),
                      // Widget 2
                      infoCard(time: '₺${savedMoney.toInt()}', header: 'Saved Money'),
                      // Widget 3
                      infoCard(
                          time: '  ${myDuration.inDays}  ',
                          header: 'Days Quit'),
                      // Widget 4
                      infoCard(
                          time: ' %${(myDuration.inDays / 180 * 100).toInt()} ',
                          header: 'Gained Health'),
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

  Widget infoCard({required String time, required String header}) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white,
                width: 5,
              ),
            ),
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(header),
        ],
      );

  Widget buildTime() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(myDuration.inDays);
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTimeCard(time: days, header: "DAYS"),
          const SizedBox(width: 5),
          buildTimeCard(time: hours, header: "HOURS"),
          const SizedBox(width: 5),
          buildTimeCard(time: minutes, header: "MINUTES"),
          const SizedBox(width: 5),
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
                fontSize: 35,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(header),
        ],
      );
}
