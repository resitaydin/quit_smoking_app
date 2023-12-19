import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginui/models/user.dart';

class DatabaseService {
  // user id from firebase (taken on sign-in/register)
  final String? uid;
  late DateTime last_date_smoked = DateTime.now();
  int cigaratte_daily_smoked = 0;
  int cigaratte_amount_per_pack = 0;
  int price_per_pack = 0;

  // constructor
  DatabaseService({this.uid});

  // users collection reference
  // automatically creates if not found
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('user-details');

  // called when a new user signs up (register) to create user
  // also called when updating any user fields
  Future updateUserData(int cig_amount, int cig_daily_smoked, String email,
      String last_date, int price, int user_id, String username) async {
    // set fields in this users document
    return await usersCollection.doc(uid).set({
      'cigaratte_amount_per_pack': cig_amount,
      'cigaratte_daily_smoked': cig_daily_smoked,
      'email': email,
      'last_date_smoked': last_date,
      'price_per_pack': price,
      'user_id': user_id,
      'username': username
    });
  }

  void updateData(int cigaratte_amount_per_pack, int cigaratte_daily_smoked,
      DateTime last_date_smoked, int price_per_pack) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('user-details');
    return collection.doc(uid).update({
      'cigaratte_amount_per_pack': cigaratte_amount_per_pack,
      'cigaratte_daily_smoked': cigaratte_daily_smoked,
      'last_date_smoked': last_date_smoked,
      'price_per_pack': price_per_pack,
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
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }
}
