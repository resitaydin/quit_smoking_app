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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        Center(child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // This will center the buttons vertically
            children: [
              SizedBox(
                width: double.infinity, // This will make the button full width
                height: 50, // Specify the height of the button
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.update),
                  label: const Text('Update User Information'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserInfoPage.update(uid: LocalStorageService().getUid()),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity, // This will make the button full width
                height: 50, // Specify the height of the button
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('I Smoked Again'),
                  onPressed: () {
                    FirebaseFirestore.instance
                          .collection('user-details')
                          .doc(LocalStorageService().getUid())
                          .update({'last_date_smoked': DateTime.now()});
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Sorry to hear that'),
                          actions: [
                              Center(
                                child: TextButton(
                                child: const Text('Continue'),
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
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity, // This will make the button full width
                height: 50, // Specify the height of the button
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 235, 104, 95), // change the color to match your theme
                  ),
                  onPressed: () {
                    _auth.signOut();
                  },
                ),
              ),
            ],
          )
        )
      ),
      backgroundColor: const Color.fromARGB(255, 127, 173, 196), // Set the background color of the page
    );
  }
}