import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginui/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final DatabaseService _dbService = DatabaseService();
  User? user = FirebaseAuth.instance.currentUser;

  static final LocalStorageService _instance = LocalStorageService._internal();

  LocalStorageService._internal() {
    setData();
    getUid();
  }

  Future<void> setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fetch data from DB
    await _dbService.fetchData();

    // Store data
    prefs.setInt('cigaratte_daily_smoked', _dbService.cigaratte_daily_smoked);
    prefs.setInt(
        'cigaratte_amount_per_pack', _dbService.cigaratte_amount_per_pack);
    prefs.setInt('price_per_pack', _dbService.price_per_pack);
    prefs.setString(
        'last_date_smoked', _dbService.last_date_smoked.toIso8601String());
    user = FirebaseAuth.instance.currentUser;
  }

  Future<Map<String, dynamic>> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'cigaratte_daily_smoked': prefs.getInt('cigaratte_daily_smoked'),
      'cigaratte_amount_per_pack': prefs.getInt('cigaratte_amount_per_pack'),
      'price_per_pack': prefs.getInt('price_per_pack'),
      'last_date_smoked':
          DateTime.parse(prefs.getString('last_date_smoked') ?? ''),
    };
  }

  // Save the last message time
  void saveLastMessageTime(TimeOfDay lastMessageTime) {
    _dbService.lastMessageTime = lastMessageTime;
  }

  // Load the last message time
  TimeOfDay? loadLastMessageTime() {
    return _dbService.lastMessageTime;
  }

  int getCigaratteDailySmoked() {
    return _dbService.cigaratte_daily_smoked;
  }

  int getCigaratteAmountPerPack() {
    return _dbService.cigaratte_amount_per_pack;
  }

  int getPricePerPack() {
    return _dbService.price_per_pack;
  }

  DateTime getLastDateSmoked() {
    return _dbService.last_date_smoked;
  }

  String getUid() {
    return user!.uid;
  }

  factory LocalStorageService() {
    return _instance;
  }
}
