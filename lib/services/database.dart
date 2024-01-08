import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  // user id from firebase (taken on sign-in/register)
  final String? uid;
  late DateTime last_date_smoked = DateTime.now();
  int cigaratte_daily_smoked = 0;
  int cigaratte_amount_per_pack = 0;
  int price_per_pack = 0;
  TimeOfDay? lastMessageTime;

  // constructor
  DatabaseService({this.uid});

  // users collection reference
  // automatically creates if not found
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('user-details');

  // called when a new user signs up (register) to create user
  // also called when updating any user fields
  Future updateUserData(int cigAmount, int cigDailySmoked, String email,
      String lastDate, int price, int userId, String username) async {
    // set fields in this users document
    return await usersCollection.doc(uid).set({
      'cigaratte_amount_per_pack': cigAmount,
      'cigaratte_daily_smoked': cigDailySmoked,
      'email': email,
      'last_date_smoked': lastDate,
      'price_per_pack': price,
      'user_id': userId,
      'username': username,
      'last_message_time': lastMessageTime,
    });
  }

  void updateData(int cigaratteAmountPerPack, int cigaratteDailySmoked,
      DateTime lastDateSmoked, int pricePerPack) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('user-details');
    return collection.doc(uid).update({
      'cigaratte_amount_per_pack': cigaratteAmountPerPack,
      'cigaratte_daily_smoked': cigaratteDailySmoked,
      'last_date_smoked': lastDateSmoked,
      'price_per_pack': pricePerPack,
      'last_message_time': lastMessageTime,
    });
  }

  Future<void> fetchData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final querySnapshot = await FirebaseFirestore
          .instance // this just retrieves a specific user's info
          .collection('user-details') // must update with uid
          .doc(user!.uid) //'oSbc780WEjeng6CrUWLc'
          .get();

      Timestamp timestamp = querySnapshot.data()?['last_date_smoked'];
      last_date_smoked = timestamp.toDate();
      cigaratte_daily_smoked = querySnapshot.data()?['cigaratte_daily_smoked'];
      cigaratte_amount_per_pack =
          querySnapshot.data()?['cigaratte_amount_per_pack'];
      price_per_pack = querySnapshot.data()?['price_per_pack'];
      lastMessageTime = querySnapshot.data()?['last_message_time'];
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }
}
