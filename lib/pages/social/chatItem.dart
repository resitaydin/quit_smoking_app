
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
        // debugPrint("user_id: $user_idcontent: $contentparental_id: $parental_idcreated_at: $created_atuid: $uid");
      }
}
