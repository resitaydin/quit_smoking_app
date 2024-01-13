import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginui/pages/userInfo/UserInfoPage.dart';
import 'package:loginui/services/auth.dart';
import 'package:loginui/services/local_storage_service.dart';

class SettingsPage extends StatelessWidget {
  final AuthService _auth = AuthService();

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // This will center the buttons vertically
            children: [
              SizedBox(
                width: double.infinity, // This will make the button full width
                height: 70, // Specify the height of the button
                child: Material(
                  elevation: 5.0, // This adds a shadow
                  borderRadius: BorderRadius.circular(
                      30.0), // This changes the shape of the button
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.update, color: Colors.black),
                    label: const Text(
                      'Update User Information',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Increase the font size
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30.0), // This changes the shape of the button
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInfoPage.update(
                              uid: LocalStorageService().getUid()),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity, // This will make the button full width
                height: 70, // Specify the height of the button
                child: Material(
                  elevation: 5.0, // This adds a shadow
                  borderRadius: BorderRadius.circular(
                      30.0), // This changes the shape of the button
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, color: Colors.black),
                    label: const Text(
                      'I Smoked Again',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Increase the font size
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30.0), // This changes the shape of the button
                      ),
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('user-details')
                          .doc(LocalStorageService().getUid())
                          .update({'last_date_smoked': DateTime.now()});
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Sorry to hear that',
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              Center(
                                child: TextButton(
                                  child: const Text(
                                    'Continue',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity, // This will make the button full width
                height: 70, // Specify the height of the button
                child: Material(
                  elevation: 5.0, // This adds a shadow
                  borderRadius: BorderRadius.circular(
                      30.0), // This changes the shape of the button
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout, color: Colors.black),
                    label: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Increase the font size
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30.0), // This changes the shape of the button
                      ),
                    ),
                    onPressed: () {
                      _auth.signOut();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
