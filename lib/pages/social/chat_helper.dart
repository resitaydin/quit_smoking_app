import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHelper {
  QuerySnapshot<Map<String, dynamic>>? ref;
  bool fetched = false;
  static final ChatHelper _instance = ChatHelper._internal();

  ChatHelper._internal() {
    fetchUsers();
  }

  Future<String> getUserName(String userId) async {
    while (!fetched) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    final docs = ref!.docs;
    for (var doc in docs) {
      if (doc.id == userId) {
        return doc.data()['username'];
      }
    }
    return 'Unknown';
  }

  Future<void> fetchUsers() async {
    final ref =
        await FirebaseFirestore.instance.collection('user-details').get();
    this.ref = ref;
    fetched = true;
  }

  factory ChatHelper() {
    return _instance;
  }
}
