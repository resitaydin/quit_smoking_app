import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loginui/pages/UiComponentScripts/UiButton.dart';
import 'package:loginui/pages/home/navigatorBarPage.dart';
import 'package:loginui/pages/userInfo/widgets/greenIntroWidget.dart';
import 'package:loginui/pages/userInfo/widgets/textWidget.dart';
import 'package:loginui/services/database.dart';
import 'package:loginui/services/local_storage_service.dart';

class UserInfoPage extends StatefulWidget {
  final String? uid;

  const UserInfoPage({Key? key, this.uid}) : super(key: key);
  const UserInfoPage.update({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController amountPerPacketController = TextEditingController();
  TextEditingController dailySmokedController = TextEditingController();
  TextEditingController pricePerPackController = TextEditingController();
  TextEditingController lastSmokeDateController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int cigaratte_amount_per_pack = 0;
  int cigaratte_daily_smoked = 0;
  int price_per_pack = 0;
  DateTime last_date_smoked = DateTime.now();

  late TextEditingController dateController;
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    timeController = TextEditingController();
    if (widget.uid != null) {
      dateController.text = DateFormat('dd MM yyyy').format(
        LocalStorageService()
            .getLastDateSmoked(), // Fixed formatting error by updating here.
      );
      timeController.text = LocalStorageService()
          .getLastDateSmoked()
          .toString()
          .substring(11, 16);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green, // used for the header background
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.green, // used for the text in the dialog buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != DateTime.now()) {
      dateController.text =
          "${picked.day} ${picked.month} ${picked.year}"; // Format the date as you desire
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              onSurface: Colors.black, // used for the text on the picker
              secondary:
                  Color.fromARGB(255, 97, 182, 100), // used for the AM/PM text
              primary: Colors.green, // used for the header background
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.green, // used for the text in the dialog buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      timeController.text = "${picked.hour}:${picked.minute}";
    }
  }

  Future<void> submitUserInfo() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Update values after form validation
    cigaratte_amount_per_pack =
        int.tryParse(amountPerPacketController.text) ?? 0;
    cigaratte_daily_smoked = int.tryParse(dailySmokedController.text) ?? 0;
    price_per_pack = int.tryParse(pricePerPackController.text) ?? 0;
    _updateLastSmokeDate();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Create an instance of DatabaseService
      DatabaseService dbService = DatabaseService(uid: user.uid);

      // Call updateUserInfo on the DatabaseService instance
      dbService.updateData(
        cigaratte_amount_per_pack,
        cigaratte_daily_smoked,
        last_date_smoked,
        price_per_pack,
      );
    }

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NavigatorBarPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.uid != null ? const BackButton() : null,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            greenIntroWidget(),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    textWidget(
                        'cigaratte amount per pack', amountPerPacketController,
                        (String? input) {
                      if (input!.isEmpty) {
                        return 'Cigaratte amount per pack is required!';
                      }

                      if (!input.isNum) {
                        return 'Please enter a valid data!';
                      }

                      return null;
                    },
                        defaultValue: widget.uid != null
                            ? LocalStorageService()
                                .getCigaratteAmountPerPack()
                                .toString()
                            : null),
                    const SizedBox(
                      height: 10,
                    ),
                    textWidget('daily smoked amount', dailySmokedController,
                        (String? input) {
                      if (input!.isEmpty) {
                        return 'Daily smoked amount is required!';
                      }
                      if (!input.isNum) {
                        return 'Please enter a valid data!';
                      }

                      return null;
                    },
                        defaultValue: widget.uid != null
                            ? LocalStorageService()
                                .getCigaratteDailySmoked()
                                .toString()
                            : null),
                    const SizedBox(
                      height: 10,
                    ),
                    textWidget('price per pack', pricePerPackController,
                        (String? input) {
                      if (input!.isEmpty) {
                        return 'Price per pack is required!';
                      }
                      if (!input.isNum) {
                        return 'Please enter a valid data!';
                      }

                      return null;
                    },
                        defaultValue: widget.uid != null
                            ? LocalStorageService().getPricePerPack().toString()
                            : null),

                    const SizedBox(
                      height: 20,
                    ),

                    InkWell(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors
                                .grey[200], // Customize the background color
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: dateController,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors
                                        .green, // Customize the text color
                                  ),
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    hintText: 'Select Date',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons
                                      .calendar_today, // You can use any date-related icon
                                  color:
                                      Colors.green, // Customize the icon color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // Time Picker
                    InkWell(
                      onTap: () => _selectTime(context),
                      child: AbsorbPointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors
                                .grey[200], // Customize the background color
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: timeController,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors
                                        .green, // Customize the text color
                                  ),
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    hintText: 'Select Time',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons
                                      .access_time, // You can use any time-related icon
                                  color:
                                      Colors.green, // Customize the icon color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    UiButton(
                      buttonName: "Submit",
                      onTap: submitUserInfo,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _updateLastSmokeDate() {
    setState(() {
      String dateTimeString = '${dateController.text} ${timeController.text}';
      DateFormat format = DateFormat("dd MM yyyy HH:mm");
      DateTime combinedDateTime = format.parse(dateTimeString);
      last_date_smoked = Timestamp.fromDate(combinedDateTime).toDate();
      // Convert Timestamp to DateTime using toDate()
    });
  }
}
