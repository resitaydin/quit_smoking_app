
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
        // Intentionally left blank.
      }
}
