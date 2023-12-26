import 'package:flutter/foundation.dart';

class Post {
  String user_id;
  String content;
  String parental_id;
  String? uid = "";
  DateTime created_at;

  Post(
      {required this.user_id,
      required this.content,
      required this.parental_id,
      required this.created_at,
      this.uid})
      {
        debugPrint("user_id: $user_id" + "content: $content" + "parental_id: $parental_id" + "created_at: $created_at" + "uid: $uid");
      }
}
