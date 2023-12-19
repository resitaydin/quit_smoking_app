import 'package:flutter/material.dart';

class Post {
  String user_id = "";
  int post_id = -1;
  String content = '';
  int parental_id = -1;

  Post(
      {required this.user_id,
      required this.post_id,
      required this.content,
      required this.parental_id}) {
    debugPrint('Post: $user_id, $post_id, $content, $parental_id');
  }
}
